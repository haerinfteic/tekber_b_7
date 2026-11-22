# Tindak lanjut feedback progress

| # | Feedback | Status | Lokasi |
|---|----------|--------|--------|
| 1 | Penerapan CRUD | Selesai, teruji | bagian 1 |
| 2 | Verifikasi user dengan email sungguhan | Kode siap; butuh SMTP (langkah manual) | bagian 2 |
| 3 | Hapus akun | Selesai, teruji | bagian 3 |
| 4 | Cara menghindari double booking | Selesai, teruji serentak | bagian 4 |
| 5 | ERD | Selesai | bagian 5 (`docs/erd.md`) |

## 1. CRUD

| Operasi | Entitas | Di aplikasi | Di database |
|---------|---------|-------------|-------------|
| **C**reate | Akun | Sign Up | trigger `handle_new_user` membuat baris `profiles` |
| **C**reate | Pesanan | Pesan Sekarang | RPC `create_booking` -> `bookings`, `booked_slots`, `payments` |
| **R**ead | Lapangan | Browse Facilities | `select` pada `facilities` (publik) |
| **R**ead | Jadwal | Pilih jam (real-time) | `select/stream` pada `booked_slots` |
| **R**ead | Riwayat & profil | Order History, Profil | `select` pada `bookings`, `profiles` (hanya milik sendiri, RLS) |
| **U**pdate | Profil | Profil > Simpan | `update profiles` (RLS: hanya baris sendiri) |
| **U**pdate | Status bayar | Bayar | RPC `pay_booking_simulated` |
| **D**elete | Pesanan | Order History > ikon tempat sampah | RPC `cancel_booking` (hanya yang belum dibayar) |
| **D**elete | Akun | Profil > Hapus akun | RPC `delete_my_account` |

Semua penulisan ke `bookings`, `booked_slots`, dan `payments` hanya lewat fungsi di atas
(tidak ada policy INSERT/UPDATE/DELETE langsung), jadi aturan bisnis tidak bisa dilewati dari aplikasi.

## 2. Verifikasi email sungguhan

**Sudah ada di kode:** setelah Sign Up, aplikasi menampilkan "cek email untuk verifikasi";
Sign In sebelum verifikasi ditolak dengan pesan jelas dan tombol "Kirim ulang email verifikasi".

**Yang perlu diatur di dashboard (sekali saja):**

1. Authentication > Sign In / Providers > nyalakan **Confirm email**.
2. Supabase bawaan hanya mengirim email ke anggota organisasi dan dibatasi sangat kecil.
   Agar email sampai ke siapa pun, pasang **Custom SMTP**:
   Authentication > Emails > **SMTP Settings** > Enable custom SMTP. Pilihan gratis:
   - Gmail: host `smtp.gmail.com`, port `465`, user = alamat Gmail, password = **App Password**
     (Akun Google > Keamanan > Verifikasi 2 langkah > App passwords).
   - Resend / Brevo: ikuti panduan SMTP masing-masing (butuh API key sebagai password).
3. Authentication > URL Configuration: isi **Site URL** (mis. `http://localhost:xxxx` saat uji web)
   dan tambahkan **Redirect URLs** yang dipakai aplikasi.
4. (Opsional) Authentication > Emails > Templates: ubah teks "Confirm signup" ke Bahasa Indonesia.

Untuk mahasiswa yang login dengan NRP, email dibentuk `<nrp>@student.its.ac.id`
(asumsi; pastikan format ini benar agar email verifikasi sampai ke inbox mereka).

Saat development, "Confirm email" boleh dimatikan agar tes cepat.

## 3. Hapus akun

`delete_my_account()` menghapus baris di `auth.users` milik pemanggil. Karena foreign key memakai
`ON DELETE CASCADE`, ikut terhapus: `profiles` -> `bookings` -> `booked_slots` dan `payments`.
Fungsi tidak bisa dipanggil tanpa login, dan hanya bisa menghapus akun sendiri (`auth.uid()`).
Di aplikasi ada dialog konfirmasi sebelum akun dihapus.

## 4. Cara menghindari double booking

Berlapis, semuanya di sisi database (aplikasi tidak perlu dipercaya):

1. **UNIQUE (facility_id, slot_date, start_hour) di `booked_slots`.** Satu jam pada satu lapangan
   dan tanggal hanya bisa memiliki satu baris. Insert kedua gagal.
2. **EXCLUDE constraint `bookings_no_overlap`** (btree_gist): dua pesanan aktif
   (`pending/paid/completed`) pada lapangan dan tanggal yang sama tidak boleh punya rentang jam beririsan.
3. **Fungsi `create_booking` bersifat atomik.** Pesanan, penguncian slot, dan tagihan dibuat dalam satu
   transaksi; kalau ada yang bentrok, semuanya dibatalkan dan user mendapat pesan
   "Slot sudah dipesan orang lain".
4. **Batas bayar 15 menit.** Pesanan yang tidak dibayar menjadi `expired` dan slotnya dibuka lagi
   (`expire_unpaid_bookings`), jadi slot tidak tertahan selamanya.
5. **Realtime.** Aplikasi berlangganan `booked_slots`, sehingga jam yang baru dipesan orang lain
   langsung abu-abu tanpa refresh (mengurangi peluang user memilih slot yang sudah terisi).

**Bukti uji (di project Supabase live):** dua user memesan jam yang beririsan pada saat bersamaan
(`Promise.all`), 5 ronde pada tanggal berbeda. Hasil: tepat satu pesanan berhasil di setiap ronde,
pemesan lainnya menerima pesan penolakan. Setelah pesanan pending dibatalkan, slot terbuka kembali
dan user lain bisa memesannya.

## 5. ERD

- Diagram Mermaid (tampil otomatis di GitHub): `docs/erd.md`
- Gambar PNG/SVG untuk laporan: dibuat dari sumber Graphviz `erd.dot` (ada di file zip proyek).

Relasi: `auth.users` 1:1 `profiles`; `profiles` 1:N `bookings`; `facilities` 1:N `bookings`;
`facilities` 1:N `booked_slots`; `bookings` 1:N `booked_slots`; `bookings` 1:1 `payments`.

## Batasan yang diketahui

- Pesanan yang sudah dibayar tidak bisa dibatalkan (belum ada refund; sesuai batasan laporan).
- Menghapus akun juga menghapus riwayat pesanan akun tersebut.
- Pembayaran QRIS masih simulasi.
