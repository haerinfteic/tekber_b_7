# FasorITS

FasorITS (Fasilitas Olahraga ITS) adalah aplikasi reservasi fasilitas olahraga di lingkungan Institut Teknologi Sepuluh Nopember (ITS). Pengguna dapat mencari lapangan, memilih tanggal dan slot waktu secara real-time, membayar melalui QRIS, dan memantau riwayat pesanan dalam satu aplikasi.

Project ini dibuat untuk memenuhi Final Project mata kuliah Teknologi Berkembang, Departemen Sistem Informasi, ITS Surabaya.

## Fitur Utama

- Autentikasi (Sign In dan Sign Up) dengan verifikasi email
- Beranda dan direktori fasilitas olahraga (Facilities Directory sesuai desain Figma, dengan filter kategori, indoor/outdoor, ketersediaan, urut harga, dan pagination)
- Pemesanan lapangan (pilih tanggal dan slot waktu real-time, tanpa double booking)
- Pembayaran QRIS (simulasi)
- Riwayat pesanan, batalkan pesanan yang belum dibayar
- Profil: ubah nama dan hapus akun

CRUD, anti double booking, verifikasi email, hapus akun, dan ERD dijelaskan di [`docs/FEEDBACK.md`](docs/FEEDBACK.md).

## Teknologi

- [Flutter](https://flutter.dev/) dan Dart
- [Supabase](https://supabase.com/) (PostgreSQL, autentikasi, dan realtime)
- Figma (desain antarmuka)
- GitHub (kolaborasi tim)

## Anggota Kelompok 7

| No | Nama | NRP |
|----|------|-----|
| 1 | Pande Made Yonata Axel Eldrian | 5026241018 |
| 2 | Riu Shandy Lintar Pratama | 5026241046 |
| 3 | Pasha Avatar Ardan | 5026241066 |
| 4 | Aiman Rediansyah Abd. Azis | 5026241068 |
| 5 | Fayza Vicka Khairina | 5026241101 |
| 6 | Anggraita Prabawati | 5026241103 |
| 7 | Widda Farrah Kayla | 5026241119 |

## Struktur Project

| Path | Isi |
|------|-----|
| `lib/main.dart` | Inisialisasi Supabase + kanvas desain 780px yang diskalakan ke layar (agar sama dengan Figma) |
| `lib/ui.dart` | Token desain Figma (warna, font Geist), NavBar, Footer, input, tombol, helper format |
| `lib/pages/landing_page.dart` | Landing Page (hero, pencarian, fitur, Cabang Populer, promo) |
| `lib/pages/auth_pages.dart` | Sign In dan Sign Up (verifikasi email, lupa password, tombol Google) |
| `lib/pages/facilities_directory.dart` | Facilities Directory (filter, kartu, pagination) |
| `lib/pages/facility_detail.dart` | Detail Lapangan + pilih tanggal/jam real-time + Fasilitas Lainnya |
| `lib/pages/payment_page.dart` | Metode Pembayaran (QRIS simulasi) + Ringkasan Pesanan |
| `lib/pages/order_history.dart` | Riwayat Pesanan (tab Semua / Berlangsung / Riwayat, batalkan pesanan) |
| `lib/pages/profile_page.dart` | Profil, Sign Out, Hapus akun |
| `assets/images/` | Foto lapangan, logo, ikon cabang (diambil dari desain Figma) |
| `lib/services/supabase_service.dart` | Semua query dan RPC Supabase (satu pintu) |
| `supabase/schema.sql` | Skema tabel, RLS, fungsi booking, realtime, data contoh |
| `supabase/migrations/002_crud_delete_account.sql` | Batal pesanan, hapus akun, anti double booking lapis 2 |
| `docs/erd.md` (Mermaid, tampil otomatis di GitHub) | ERD |
| `docs/FEEDBACK.md` | Tindak lanjut feedback progress |

## Menjalankan Project

Prasyarat: Flutter SDK (flutter.dev) dan Google Chrome. Cek dengan `flutter doctor`.

```bash
# 1. Masuk ke folder project
cd tekber_b_7

# 2. Buat folder platform (tidak menimpa lib/, assets/, dan pubspec.yaml)
flutter create . --platforms=android,web

# 3. Pasang dependensi dan cek kode
flutter pub get
flutter analyze

# 4. Jalankan di Chrome
flutter run -d chrome
```

Untuk Android: sambungkan HP atau buka emulator, lalu `flutter run`. Tampilan paling mendekati Figma di Chrome dengan jendela selebar 780 px atau lebih.

### Cek hasilnya

1. Landing Page tampil. Klik **Browse Facilities**: harus ada 6 lapangan dengan foto.
2. **Sign Up** lalu masuk. Jika Confirm email aktif di Supabase, klik link di email dulu.
3. Buka sebuah lapangan, pilih tanggal dan jam, **Pesan Sekarang**, lalu **Bayar Sekarang**. Pesanan muncul di **Order History**.
4. Pesan jam yang sama dari akun lain: harus ditolak dengan pesan "Slot sudah dipesan orang lain".

### Jika error

- Font tidak muncul: pastikan ada internet (font Geist diambil dari Google Fonts).
- Layar putih atau error Supabase: periksa URL dan key di `lib/main.dart`.
- Foto tidak muncul: jalankan `flutter pub get` lagi, lalu restart penuh (bukan hot reload).
- Tim satu database: teman cukup memakai kode yang sama dan menjalankan langkah 2 sampai 4. Data booking langsung terlihat di semua orang.

## Supabase

Backend memakai project Supabase `tekberProject`.

- Project URL dan **publishable key** ada di `lib/main.dart`. Key ini memang dirancang untuk dipakai di aplikasi; data tetap dilindungi Row Level Security (RLS).
- Setup database: Dashboard > SQL Editor > jalankan `supabase/schema.sql`, lalu `supabase/migrations/002_crud_delete_account.sql`.
- Verifikasi email sungguhan butuh Custom SMTP, lihat `docs/FEEDBACK.md` bagian 2. Saat development, Confirm email boleh dimatikan.
- Tabel `bookings`, `booked_slots`, dan `payments` tidak bisa ditulis langsung dari aplikasi; semuanya lewat fungsi database.

## Cara Berkontribusi

Alur branch per fitur dan pull request. Jangan push langsung ke branch `main`.

```bash
git checkout main
git pull origin main
git checkout -b feature/nama-fitur
git add .
git commit -m "feat: tambah halaman pilih tanggal"
git pull origin main
git push -u origin feature/nama-fitur
```

Lalu buka GitHub, klik **Compare & pull request**, pilih minimal satu reviewer, **Merge** setelah disetujui, dan hapus branch yang sudah di-merge.

| Tipe | Contoh branch |
|------|---------------|
| Fitur baru | `feature/pemesanan-lapangan` |
| Perbaikan bug | `fix/slot-waktu-ganda` |
| Dokumentasi | `docs/update-readme` |

Format pesan commit: `feat:`, `fix:`, `docs:`, `style:`, `refactor:`.

## Aturan Singkat

- Satu branch untuk satu fitur atau satu perbaikan.
- Pastikan kode tidak error sebelum membuat pull request.
- Jalankan `flutter analyze` dan `dart format .` sebelum commit.
- Jangan commit file rahasia: password database, secret key, atau `service_role` key Supabase. Simpan di file `.env` yang sudah masuk `.gitignore`.
- Jika bingung atau menemukan konflik, tanyakan di grup sebelum melakukan merge.

## Lisensi

Project ini dibuat untuk keperluan akademik.

## Foto Lapangan

Kartu lapangan menampilkan foto dari kolom `facilities.image_url`; bila kosong, tampil ikon olahraga. Cara mengisi:

1. Supabase Dashboard > Storage > New bucket `facility-images` (centang **Public bucket**).
2. Upload foto, lalu salin **Public URL**.
3. Table Editor > `facilities` > isi kolom `image_url` dengan URL tersebut.

## Sinkron dengan Desain Figma

Seluruh layar mengikuti frame hi-fi (Sign In, Sign Up, Landing, Daftar Lapangan, Detail Lapangan, Metode Pembayaran, Riwayat Pesanan). UI digambar pada kanvas selebar 780px (lebar frame Figma) lalu diskalakan ke lebar layar. Font memakai Geist lewat paket `google_fonts` (butuh internet saat pertama dijalankan).

Jalankan migration `supabase/migrations/003_figma_facilities.sql` agar data lapangan sama dengan desain. Migration ini tidak menghapus data: fasilitas lama di-update di tempat.

Login Google: tombolnya sudah ada, tetapi baru berfungsi setelah provider Google diaktifkan di Supabase (Authentication > Sign In / Providers > Google).
