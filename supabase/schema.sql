-- =====================================================================
-- FasorITS - Skema database Supabase (PostgreSQL)
-- Cara pakai: Supabase Dashboard -> SQL Editor -> New query -> paste -> Run
-- Aman dijalankan ulang (idempotent) selama belum ada data penting.
-- =====================================================================

create extension if not exists pgcrypto;

-- ---------------------------------------------------------------------
-- 1. TABEL
-- ---------------------------------------------------------------------

-- Profil pengguna (1 baris per akun di auth.users)
create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  full_name   text,
  nrp         text unique,
  email       text,
  user_type   text not null default 'umum' check (user_type in ('mahasiswa','umum')),
  created_at  timestamptz not null default now()
);

-- Fasilitas / lapangan
create table if not exists public.facilities (
  id             uuid primary key default gen_random_uuid(),
  name           text not null,
  category       text not null check (category in ('badminton','futsal','basket','tenis','voli','atletik')),
  location       text,
  description    text,
  price_per_hour integer not null check (price_per_hour >= 0),
  rating         numeric(2,1) not null default 0,
  is_indoor      boolean not null default false,
  is_popular     boolean not null default false,
  image_url      text,
  open_hour      integer not null default 6  check (open_hour between 0 and 23),
  close_hour     integer not null default 22 check (close_hour between 1 and 24),
  amenities      text[] not null default '{}',
  rules          text[] not null default '{}',
  created_at     timestamptz not null default now()
);

-- Pesanan
create table if not exists public.bookings (
  id            uuid primary key default gen_random_uuid(),
  booking_code  text unique not null default ('FSR-' || upper(substr(md5(random()::text), 1, 6))),
  user_id       uuid not null references public.profiles(id) on delete cascade,
  facility_id   uuid not null references public.facilities(id),
  booking_date  date not null,
  start_hour    integer not null,
  end_hour      integer not null,           -- eksklusif: 19-21 berarti jam 19:00-21:00
  rental_fee    integer not null,
  service_fee   integer not null default 0,
  total         integer not null,
  status        text not null default 'pending'
                check (status in ('pending','paid','completed','expired','cancelled')),
  created_at    timestamptz not null default now()
);

-- Slot yang sudah terisi. Constraint UNIQUE inilah yang mencegah double booking
-- dan tabel ini dibaca publik supaya jadwal tampil real-time ke semua user.
create table if not exists public.booked_slots (
  id           bigint generated always as identity primary key,
  facility_id  uuid not null references public.facilities(id) on delete cascade,
  slot_date    date not null,
  start_hour   integer not null check (start_hour between 0 and 23),
  booking_id   uuid not null references public.bookings(id) on delete cascade,
  unique (facility_id, slot_date, start_hour)
);

-- Pembayaran (simulasi QRIS)
create table if not exists public.payments (
  id              uuid primary key default gen_random_uuid(),
  booking_id      uuid not null unique references public.bookings(id) on delete cascade,
  method          text not null default 'QRIS',
  amount          integer not null,
  status          text not null default 'pending'
                  check (status in ('pending','paid','failed','expired')),
  transaction_id  text,
  expires_at      timestamptz not null,
  paid_at         timestamptz
);

create index if not exists idx_bookings_user on public.bookings(user_id, created_at desc);
create index if not exists idx_slots_lookup  on public.booked_slots(facility_id, slot_date);

-- ---------------------------------------------------------------------
-- 2. AUTO-BUAT PROFIL SAAT USER SIGN UP
--    Flutter mengirim full_name, nrp, user_type lewat `data:` di signUp()
-- ---------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, full_name, nrp, email, user_type)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name'),
    nullif(new.raw_user_meta_data->>'nrp', ''),
    new.email,
    coalesce(new.raw_user_meta_data->>'user_type', 'umum')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------
-- 3. FUNGSI (RPC) - logika booking dijalankan atomik di server
-- ---------------------------------------------------------------------

-- Bersihkan pesanan pending yang lewat batas bayar -> slot terbuka lagi
create or replace function public.expire_unpaid_bookings()
returns void
language plpgsql security definer set search_path = public as $$
begin
  update public.payments
     set status = 'expired'
   where status = 'pending' and expires_at < now();

  update public.bookings b
     set status = 'expired'
    from public.payments p
   where p.booking_id = b.id and p.status = 'expired' and b.status = 'pending';

  delete from public.booked_slots s
   using public.bookings b
   where s.booking_id = b.id and b.status = 'expired';
end;
$$;

-- Buat pesanan + kunci slot + buat tagihan. Return: id pesanan.
-- p_hours contoh: {19,20} = jam 19:00-21:00 (harus berurutan)
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
  exception when unique_violation then
    raise exception 'Slot sudah dipesan orang lain, silakan pilih slot lain';
  end;

  insert into public.payments (booking_id, amount, expires_at)
  values (v_booking, v_rental + v_service, now() + interval '15 minutes');

  return v_booking;
end;
$$;

-- Simulasi pembayaran QRIS berhasil (belum payment gateway sungguhan)
create or replace function public.pay_booking_simulated(p_booking_id uuid)
returns text
language plpgsql security definer set search_path = public as $$
declare
  v_trx text := 'TRX-' || upper(substr(md5(random()::text || clock_timestamp()::text), 1, 10));
begin
  perform public.expire_unpaid_bookings();

  update public.payments p
     set status = 'paid', paid_at = now(), transaction_id = v_trx
    from public.bookings b
   where p.booking_id = b.id
     and b.id = p_booking_id
     and b.user_id = auth.uid()
     and p.status = 'pending';

  if not found then
    raise exception 'Pesanan tidak ditemukan atau waktu pembayaran sudah habis';
  end if;

  update public.bookings set status = 'paid' where id = p_booking_id;
  return v_trx;
end;
$$;

revoke execute on function public.create_booking(uuid, date, integer[])  from public, anon;
revoke execute on function public.pay_booking_simulated(uuid)            from public, anon;
revoke execute on function public.expire_unpaid_bookings()               from public, anon;
grant  execute on function public.create_booking(uuid, date, integer[])  to authenticated;
grant  execute on function public.pay_booking_simulated(uuid)            to authenticated;

-- ---------------------------------------------------------------------
-- 4. ROW LEVEL SECURITY
--    Anon key ada di dalam APK, jadi RLS WAJIB aktif.
-- ---------------------------------------------------------------------
alter table public.profiles     enable row level security;
alter table public.facilities   enable row level security;
alter table public.bookings     enable row level security;
alter table public.booked_slots enable row level security;
alter table public.payments     enable row level security;

drop policy if exists "profiles_select_own"   on public.profiles;
drop policy if exists "profiles_update_own"   on public.profiles;
drop policy if exists "facilities_read_all"   on public.facilities;
drop policy if exists "slots_read_all"        on public.booked_slots;
drop policy if exists "bookings_select_own"   on public.bookings;
drop policy if exists "payments_select_own"   on public.payments;

create policy "profiles_select_own" on public.profiles
  for select using (auth.uid() = id);
create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = id);

create policy "facilities_read_all" on public.facilities
  for select using (true);

create policy "slots_read_all" on public.booked_slots
  for select using (true);

create policy "bookings_select_own" on public.bookings
  for select using (auth.uid() = user_id);

create policy "payments_select_own" on public.payments
  for select using (
    exists (select 1 from public.bookings b
            where b.id = payments.booking_id and b.user_id = auth.uid())
  );
-- Tidak ada policy INSERT/UPDATE pada bookings, booked_slots, payments:
-- semua penulisan lewat fungsi create_booking() / pay_booking_simulated().

-- ---------------------------------------------------------------------
-- 5. REALTIME - jadwal & status pesanan ter-update otomatis di semua HP
-- ---------------------------------------------------------------------
do $$
begin
  if not exists (select 1 from pg_publication_tables
                 where pubname = 'supabase_realtime' and tablename = 'booked_slots') then
    alter publication supabase_realtime add table public.booked_slots;
  end if;
  if not exists (select 1 from pg_publication_tables
                 where pubname = 'supabase_realtime' and tablename = 'bookings') then
    alter publication supabase_realtime add table public.bookings;
  end if;
end $$;

-- ---------------------------------------------------------------------
-- 6. DATA CONTOH (hapus/ubah sesuai data asli fasilitas ITS)
-- ---------------------------------------------------------------------
insert into public.facilities
  (name, category, location, description, price_per_hour, rating, is_indoor, is_popular, amenities, rules)
select * from (values
  ('Lapangan Badminton GOR ITS', 'badminton', 'GOR ITS, Sukolilo', 'Lapangan badminton indoor dengan lantai karpet standar dan penerangan LED.', 40000, 4.7, true,  true,  array['Toilet','Parkir','Mushola','Kantin'], array['Wajib sepatu olahraga non-marking','Dilarang membawa makanan ke area lapangan']),
  ('Lapangan Futsal ITS',         'futsal',    'Kawasan Olahraga ITS', 'Lapangan futsal indoor berlantai vinyl.',                          150000, 4.6, true,  true,  array['Toilet','Parkir','Ruang ganti'], array['Wajib sepatu futsal','Maksimal 12 pemain']),
  ('Lapangan Basket ITS',         'basket',    'Kawasan Olahraga ITS', 'Lapangan basket outdoor dengan ring standar dan penerangan malam.', 80000, 4.4, false, true,  array['Toilet','Parkir','Tribun'],    array['Dilarang merokok','Jaga kebersihan area']),
  ('Lapangan Tenis ITS',          'tenis',     'Kawasan Olahraga ITS', 'Lapangan tenis outdoor permukaan keras.',                           60000, 4.3, false, false, array['Toilet','Parkir'],             array['Wajib sepatu tenis']),
  ('Lapangan Voli ITS',           'voli',      'Kawasan Olahraga ITS', 'Lapangan voli outdoor.',                                            50000, 4.2, false, false, array['Toilet','Parkir','Mushola'],   array['Dilarang membawa makanan ke area lapangan'])
) as v(name, category, location, description, price_per_hour, rating, is_indoor, is_popular, amenities, rules)
where not exists (select 1 from public.facilities);
