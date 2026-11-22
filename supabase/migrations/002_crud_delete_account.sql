-- =====================================================================
-- Migrasi 002 - CRUD lengkap, hapus akun, anti double booking berlapis
-- Jalankan SETELAH schema.sql. Aman dijalankan ulang.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. ANTI DOUBLE BOOKING - lapis ke-2
--    Lapis 1 (schema.sql): UNIQUE(facility_id, slot_date, start_hour) di booked_slots.
--    Lapis 2 (ini): tidak boleh ada dua pesanan AKTIF yang rentang jamnya
--    beririsan pada lapangan dan tanggal yang sama (exclusion constraint).
--    Dicek oleh PostgreSQL secara atomik, jadi aman walau dua user klik bersamaan.
-- ---------------------------------------------------------------------
create extension if not exists btree_gist;

do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'bookings_no_overlap') then
    alter table public.bookings
      add constraint bookings_no_overlap
      exclude using gist (
        facility_id  with =,
        booking_date with =,
        int4range(start_hour, end_hour) with &&
      ) where (status in ('pending', 'paid', 'completed'));
  end if;
end $$;

-- ---------------------------------------------------------------------
-- 2. CRUD
--    CREATE : create_booking()            (schema.sql)
--    READ   : select facilities / bookings / payments / profiles
--    UPDATE : update profiles (RLS) + pay_booking_simulated()
--    DELETE : cancel_booking() + delete_my_account()
-- ---------------------------------------------------------------------

-- DELETE pesanan: hanya pesanan yang belum dibayar (tidak ada refund).
-- Baris booked_slots dan payments ikut terhapus (ON DELETE CASCADE) -> slot terbuka lagi.
create or replace function public.cancel_booking(p_booking_id uuid)
returns void
language plpgsql security definer set search_path = public as $$
begin
  delete from public.bookings
   where id = p_booking_id
     and user_id = auth.uid()
     and status = 'pending';

  if not found then
    raise exception 'Pesanan tidak ditemukan atau sudah dibayar (tidak bisa dibatalkan)';
  end if;
end;
$$;

-- DELETE akun: hapus user di auth.users.
-- Profil, pesanan, slot, dan pembayaran milik user ikut terhapus (CASCADE).
create or replace function public.delete_my_account()
returns void
language plpgsql security definer set search_path = public, auth as $$
begin
  if auth.uid() is null then
    raise exception 'Silakan login terlebih dahulu';
  end if;
  delete from auth.users where id = auth.uid();
end;
$$;

revoke execute on function public.cancel_booking(uuid)  from public, anon;
revoke execute on function public.delete_my_account()   from public, anon;
grant  execute on function public.cancel_booking(uuid)  to authenticated;
grant  execute on function public.delete_my_account()   to authenticated;

-- UPDATE profil: user hanya boleh mengubah profilnya sendiri.
-- (policy profiles_update_own sudah ada di schema.sql; WITH CHECK ditambahkan
--  agar baris tidak bisa "dipindahkan" ke user lain)
drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = id) with check (auth.uid() = id);

-- ---------------------------------------------------------------------
-- 3. create_booking diperbarui: tangkap juga pelanggaran EXCLUDE (lapis 2)
--    supaya pesan error ke user ramah, bukan teks teknis database.
-- ---------------------------------------------------------------------
create or replace function public.create_booking(
  p_facility_id uuid,
  p_date        date,
  p_hours       integer[]
)
returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_user     uuid := auth.uid();
  v_fac      public.facilities%rowtype;
  v_hours    integer[];
  v_n        integer;
  v_min      integer;
  v_max      integer;
  v_rental   integer;
  v_service  integer := 2000;      -- biaya layanan flat, ubah sesuai kebutuhan
  v_booking  uuid;
  h          integer;
begin
  if v_user is null then
    raise exception 'Silakan login terlebih dahulu';
  end if;

  select array_agg(distinct x order by x) into v_hours from unnest(p_hours) as x;
  v_n := coalesce(array_length(v_hours, 1), 0);
  if v_n = 0 then
    raise exception 'Pilih minimal satu slot waktu';
  end if;

  v_min := v_hours[1];
  v_max := v_hours[v_n];
  if v_max - v_min + 1 <> v_n then
    raise exception 'Slot waktu harus berurutan';
  end if;

  select * into v_fac from public.facilities where id = p_facility_id;
  if not found then
    raise exception 'Lapangan tidak ditemukan';
  end if;
  if v_min < v_fac.open_hour or v_max >= v_fac.close_hour then
    raise exception 'Slot di luar jam operasional';
  end if;
  if p_date < (now() at time zone 'Asia/Jakarta')::date then
    raise exception 'Tanggal sudah lewat';
  end if;

  perform public.expire_unpaid_bookings();

  v_rental := v_fac.price_per_hour * v_n;

  begin
    insert into public.bookings
      (user_id, facility_id, booking_date, start_hour, end_hour, rental_fee, service_fee, total)
    values
      (v_user, p_facility_id, p_date, v_min, v_max + 1, v_rental, v_service, v_rental + v_service)
    returning id into v_booking;

    foreach h in array v_hours loop
      insert into public.booked_slots (facility_id, slot_date, start_hour, booking_id)
      values (p_facility_id, p_date, h, v_booking);
    end loop;
  exception when unique_violation or exclusion_violation then
    raise exception 'Slot sudah dipesan orang lain, silakan pilih slot lain';
  end;

  insert into public.payments (booking_id, amount, expires_at)
  values (v_booking, v_rental + v_service, now() + interval '15 minutes');

  return v_booking;
end;
$$;
