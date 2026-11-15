# FasorITS

**FasorITS** (Fasilitas Olahraga ITS) adalah aplikasi reservasi fasilitas olahraga di lingkungan Institut Teknologi Sepuluh Nopember (ITS). Pengguna dapat mencari lapangan, memilih tanggal dan slot waktu secara real-time, membayar melalui QRIS, dan memantau riwayat pesanan dalam satu aplikasi.

Project ini dibuat untuk memenuhi Final Project mata kuliah **Teknologi Berkembang**, Departemen Sistem Informasi, ITS Surabaya.

## Fitur Utama

- Autentikasi (Sign In dan Sign Up)
- Beranda dan direktori fasilitas olahraga
- Detail lapangan (deskripsi, fasilitas, dan peraturan)
- Pemesanan lapangan (pilih tanggal, slot waktu, dan rincian biaya)
- Pembayaran QRIS (simulasi) dan notifikasi pembayaran
- Riwayat pesanan dengan filter status

## Teknologi

- [Flutter](https://flutter.dev) dan Dart
- [Supabase](https://supabase.com) (PostgreSQL dan autentikasi)
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

## Menjalankan Project

### Prasyarat

- Flutter SDK terpasang (cek dengan `flutter doctor`)
- Git
- VS Code atau Android Studio

### Langkah

```bash
# 1. Clone repository
git clone https://github.com/USERNAME/NAMA-REPO.git
cd NAMA-REPO

# 2. Ambil dependency
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

Untuk memilih device secara langsung:

```bash
flutter run -d chrome
flutter run -d windows
```

## Cara Berkontribusi

Kami memakai alur **branch per fitur** dan **pull request**. Jangan push langsung ke branch `main`.

### 1. Ambil kode terbaru

```bash
git checkout main
git pull origin main
```

### 2. Buat branch baru

Gunakan format `tipe/nama-fitur`:

```bash
git checkout -b feature/nama-fitur
```

Contoh penamaan branch:

| Tipe | Contoh |
|------|--------|
| Fitur baru | `feature/pemesanan-lapangan` |
| Perbaikan bug | `fix/slot-waktu-ganda` |
| Dokumentasi | `docs/update-readme` |

### 3. Kerjakan dan commit

```bash
git add .
git commit -m "feat: tambah halaman pilih tanggal"
```

Format pesan commit yang disarankan:

- `feat:` untuk fitur baru
- `fix:` untuk perbaikan bug
- `docs:` untuk dokumentasi
- `style:` untuk perubahan tampilan atau format
- `refactor:` untuk perapian kode tanpa mengubah fungsi

### 4. Sinkronkan dengan `main` sebelum push

```bash
git pull origin main
```

Selesaikan konflik jika ada, lalu pastikan aplikasi masih berjalan dengan `flutter run`.

### 5. Push branch

```bash
git push -u origin feature/nama-fitur
```

### 6. Buat Pull Request

1. Buka repository di GitHub, lalu klik **Compare & pull request**.
2. Isi judul dan deskripsi singkat tentang perubahan yang dibuat.
3. Pilih minimal satu anggota lain sebagai **reviewer**.
4. Setelah disetujui, lakukan **Merge** ke `main`.
5. Hapus branch yang sudah di-merge.

### Aturan Singkat

- Satu branch untuk satu fitur atau satu perbaikan.
- Pastikan kode tidak error sebelum membuat pull request.
- Jalankan `flutter analyze` dan `dart format .` sebelum commit.
- Jangan commit file rahasia seperti API key atau kredensial Supabase. Simpan di file `.env` yang sudah masuk `.gitignore`.
- Jika bingung atau menemukan konflik, tanyakan di grup sebelum melakukan merge.

## Lisensi

Project ini dibuat untuk keperluan akademik.