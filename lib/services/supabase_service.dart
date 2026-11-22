import 'package:supabase_flutter/supabase_flutter.dart';

/// Semua akses ke Supabase lewat satu file ini, supaya UI tinggal panggil
/// FasorService.xxx() dan tidak ada query tersebar di banyak screen
/// (juga mengurangi konflik git antar anggota tim).
class FasorService {
  FasorService._();

  static final SupabaseClient _db = Supabase.instance.client;

  // ------------------------------------------------------------------
  // AUTH
  // ------------------------------------------------------------------

  /// Mahasiswa login pakai NRP -> diubah jadi email kampus.
  /// ASUMSI format email: `<nrp>@student.its.ac.id` (sesuaikan kalau beda).
  static String _toEmail(String nrpOrEmail) {
    final v = nrpOrEmail.trim();
    return v.contains('@') ? v : '$v@student.its.ac.id';
  }

  static Future<AuthResponse> signUp({
    required String fullName,
    required String nrpOrEmail,
    required String password,
  }) {
    final isStudent = !nrpOrEmail.contains('@');
    return _db.auth.signUp(
      email: _toEmail(nrpOrEmail),
      password: password,
      data: {
        'full_name': fullName,
        'nrp': isStudent ? nrpOrEmail.trim() : '',
        'user_type': isStudent ? 'mahasiswa' : 'umum',
      },
    );
  }

  static Future<AuthResponse> signIn({
    required String nrpOrEmail,
    required String password,
  }) {
    return _db.auth.signInWithPassword(
      email: _toEmail(nrpOrEmail),
      password: password,
    );
  }

  /// Kirim ulang email verifikasi (kalau email belum diverifikasi).
  static Future<void> resendVerification(String nrpOrEmail) =>
      _db.auth.resend(type: OtpType.signup, email: _toEmail(nrpOrEmail));

  /// Kirim email reset password (link dikirim lewat SMTP yang dikonfigurasi di Supabase).
  static Future<void> resetPassword(String nrpOrEmail) =>
      _db.auth.resetPasswordForEmail(_toEmail(nrpOrEmail));

  /// Login Google. Perlu provider Google diaktifkan di Supabase
  /// (Authentication > Sign In / Providers > Google).
  static Future<bool> signInWithGoogle() =>
      _db.auth.signInWithOAuth(OAuthProvider.google);

  static Future<void> signOut() => _db.auth.signOut();

  static User? get currentUser => _db.auth.currentUser;

  // ------------------------------------------------------------------
  // PROFIL  (READ + UPDATE)  &  HAPUS AKUN (DELETE)
  // ------------------------------------------------------------------

  /// READ profil milik user yang login.
  static Future<Map<String, dynamic>> getMyProfile() =>
      _db.from('profiles').select().eq('id', currentUser!.id).single();

  /// UPDATE nama lengkap (RLS: hanya boleh mengubah profil sendiri).
  static Future<void> updateMyProfile({required String fullName}) async {
    await _db
        .from('profiles')
        .update({'full_name': fullName.trim()})
        .eq('id', currentUser!.id);
  }

  /// DELETE akun: hapus user + profil + semua pesanannya (CASCADE di database).
  static Future<void> deleteMyAccount() async {
    await _db.rpc('delete_my_account');
    try {
      await _db.auth.signOut(scope: SignOutScope.local);
    } catch (_) {
      // user sudah terhapus di server; sesi lokal tetap dibersihkan
    }
  }

  // ------------------------------------------------------------------
  // FASILITAS  (Landing Page + Facilities Directory + Detail)
  // ------------------------------------------------------------------

  /// [category] contoh: 'badminton'. Null = semua.
  /// [sort]: 'price_asc' | 'price_desc' | null (default: terpopuler dulu)
  static Future<List<Map<String, dynamic>>> getFacilities({
    String? category,
    bool? indoor,
    String? sort,
  }) async {
    var q = _db.from('facilities').select();
    if (category != null) q = q.eq('category', category);
    if (indoor != null) q = q.eq('is_indoor', indoor);

    final ordered = switch (sort) {
      'price_asc' => q.order('price_per_hour', ascending: true),
      'price_desc' => q.order('price_per_hour', ascending: false),
      _ => q.order('is_popular', ascending: false).order('rating', ascending: false),
    };
    return List<Map<String, dynamic>>.from(await ordered);
  }

  /// Jumlah jam yang sudah dipesan HARI INI per lapangan (facility_id -> jumlah).
  /// Dipakai untuk label AVAILABLE / BOOKED TODAY di Facilities Directory.
  static Future<Map<String, int>> bookedCountsToday() async {
    final rows = await _db
        .from('booked_slots')
        .select('facility_id')
        .eq('slot_date', _dateOnly(DateTime.now()));
    final counts = <String, int>{};
    for (final r in rows) {
      final id = r['facility_id'] as String;
      counts[id] = (counts[id] ?? 0) + 1;
    }
    return counts;
  }

  static Future<Map<String, dynamic>> getFacility(String id) =>
      _db.from('facilities').select().eq('id', id).single();

  // ------------------------------------------------------------------
  // JADWAL REAL-TIME
  // ------------------------------------------------------------------

  /// Stream jam yang SUDAH dipesan pada [date] untuk lapangan [facilityId].
  /// Otomatis emit ulang kalau ada user lain yang memesan -> UI ikut berubah.
  /// Pakai di `StreamBuilder<Set<int>>`.
  static Stream<Set<int>> bookedHours(String facilityId, DateTime date) {
    final day = _dateOnly(date);
    return _db
        .from('booked_slots')
        .stream(primaryKey: ['id'])
        .eq('facility_id', facilityId)
        .map((rows) => rows
            .where((r) => r['slot_date'] == day)
            .map<int>((r) => r['start_hour'] as int)
            .toSet());
  }

  // ------------------------------------------------------------------
  // BOOKING & PEMBAYARAN
  // ------------------------------------------------------------------

  /// [hours] contoh [19, 20] = 19:00-21:00 (harus berurutan).
  /// Return: bookingId. Melempar PostgrestException kalau slot sudah diambil.
  static Future<String> createBooking({
    required String facilityId,
    required DateTime date,
    required List<int> hours,
  }) async {
    final res = await _db.rpc('create_booking', params: {
      'p_facility_id': facilityId,
      'p_date': _dateOnly(date),
      'p_hours': hours,
    });
    return res as String;
  }

  /// Detail pesanan + lapangan + pembayaran (untuk halaman QRIS & notifikasi).
  static Future<Map<String, dynamic>> getBooking(String bookingId) => _db
      .from('bookings')
      .select('*, facilities(name, location, address, image_url), payments(*)')
      .eq('id', bookingId)
      .single();

  /// DELETE pesanan yang belum dibayar. Slot otomatis terbuka lagi.
  /// Pesanan yang sudah dibayar tidak bisa dibatalkan (tidak ada refund).
  static Future<void> cancelBooking(String bookingId) async {
    await _db.rpc('cancel_booking', params: {'p_booking_id': bookingId});
  }

  /// Simulasi "bayar sekarang berhasil". Return: Transaction ID.
  static Future<String> payBooking(String bookingId) async {
    final res = await _db.rpc('pay_booking_simulated', params: {
      'p_booking_id': bookingId,
    });
    return res as String;
  }

  // ------------------------------------------------------------------
  // RIWAYAT PESANAN
  // ------------------------------------------------------------------

  /// [onlyActive]: true = tab "Berlangsung", false = tab "Riwayat", null = "Semua".
  static Future<List<Map<String, dynamic>>> getMyBookings({bool? onlyActive}) async {
    var q = _db
        .from('bookings')
        .select('*, facilities(name, location, address, image_url), payments(status, transaction_id)')
        .eq('user_id', currentUser!.id);

    if (onlyActive == true) q = q.inFilter('status', ['pending', 'paid']);
    if (onlyActive == false) q = q.inFilter('status', ['completed', 'expired', 'cancelled']);

    return List<Map<String, dynamic>>.from(await q.order('created_at', ascending: false));
  }

  // ------------------------------------------------------------------
  static String _dateOnly(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
