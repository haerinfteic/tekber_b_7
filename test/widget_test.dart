import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tekber_b_7/screens/facility_detail_screen.dart';
import 'package:tekber_b_7/widgets/booking_card.dart';

void main() {
  Future<void> setUpView(WidgetTester tester) async {
    tester.view.physicalSize = const Size(440 * 2, 3200 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
  }

  Future<void> pumpScreen(WidgetTester tester) async {
    await setUpView(tester);
    await tester.pumpWidget(const MaterialApp(home: FacilityDetailScreen()));
  }

  testWidgets('tab Deskripsi tampil default dengan harga & Fasilitas Lainnya',
      (tester) async {
    await pumpScreen(tester);

    // Harga memakai Text.rich (angka besar + "/jam").
    expect(find.textContaining('Rp 700.000'), findsOneWidget);
    expect(find.text('Pilih Tanggal'), findsOneWidget);
    expect(find.text('Fasilitas Lainnya'), findsOneWidget);
    expect(find.text('Lapangan Badminton'), findsOneWidget);
    expect(find.text('Rp 35.000/jam'), findsOneWidget);
  });

  testWidgets('tab Fasilitas menampilkan Fasilitas Utama & Pendukung',
      (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.text('Fasilitas'));
    await tester.pump();

    expect(find.text('Fasilitas Utama'), findsOneWidget);
    expect(find.text('Fasilitas Pendukung'), findsOneWidget);
    expect(find.text('Tribun penonton'), findsOneWidget);
    expect(find.text('Pos keamanan'), findsOneWidget);
  });

  testWidgets('tab Peraturan menampilkan daftar peraturan', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.text('Peraturan'));
    await tester.pump();

    expect(find.text('Datang 15 menit sebelum jadwal pemesanan.'),
        findsOneWidget);
    expect(find.text('Dilarang merokok di seluruh area olahraga.'),
        findsOneWidget);
    expect(find.text('Fasilitas Utama'), findsNothing);
  });

  testWidgets('tab Ulasan menampilkan rating, distribusi, dan ulasan',
      (tester) async {
    await pumpScreen(tester);

    // Tab bar bisa di-scroll horizontal; pastikan tab terlihat dulu.
    await tester.ensureVisible(find.text('Ulasan'));
    await tester.pump();
    await tester.tap(find.text('Ulasan'));
    await tester.pump();

    // Satu di header screen, satu di kartu ringkasan rating.
    expect(find.text('4.8'), findsNWidgets(2));
    expect(find.text('120 Ulasan'), findsOneWidget);
    expect(find.text('5 Bintang'), findsOneWidget);
    expect(find.text('102'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Siti Aminah'), findsOneWidget);
    expect(find.text('Lihat Semua Ulasan'), findsOneWidget);
  });

  testWidgets('booking: pilih tanggal, pilih jam, total & pesan',
      (tester) async {
    await setUpView(tester);
    DateTime? bookedDate;
    int? bookedHour;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: BookingCard(
              pricePerHour: 700000,
              serviceFee: 5000,
              today: DateTime(2026, 5, 25),
              onBook: (date, hour) {
                bookedDate = date;
                bookedHour = hour;
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Pilih Tanggal'));
    await tester.pump();
    expect(find.text('Mei 2026'), findsOneWidget);

    await tester.tap(find.text('26'));
    await tester.pump();
    await tester.tap(find.text('Pilih'));
    await tester.pump();

    expect(find.text('Selasa, 26 Mei 2026'), findsOneWidget);
    expect(find.text('Pilih Waktu Tersedia'), findsOneWidget);
    expect(find.text('Total Tagihan'), findsNothing);

    // Jam yang sudah terpesan tidak bisa dipilih.
    await tester.tap(find.text('08:00'));
    await tester.pump();
    expect(find.text('Total Tagihan'), findsNothing);

    await tester.tap(find.text('17:00'));
    await tester.pump();
    expect(find.text('Rp 705.000'), findsOneWidget);
    expect(find.text('Rp 5.000'), findsOneWidget);

    await tester.tap(find.text('Pesan Sekarang'));
    await tester.pump();
    expect(bookedDate, DateTime(2026, 5, 26));
    expect(bookedHour, 17);
  });
}
