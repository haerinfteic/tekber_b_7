class AppUser {
  const AppUser({
    required this.name,
    required this.nrp,
    required this.email,
  });

  final String name;
  final String nrp;
  final String email;
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Layanan autentikasi SEMENTARA (data tiruan, tanpa backend).
///
/// Nanti ganti isi [deleteAccount] dengan pemanggilan Supabase:
///   1. verifikasi ulang password (signInWithPassword), lalu
///   2. hapus akun lewat RPC / Edge Function di server, karena menghapus
///      user auth tidak bisa dilakukan langsung dari aplikasi dengan anon key.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  /// Password akun demo. Dipakai untuk mencoba kasus "password salah".
  static const demoPassword = 'fasorits123';

  static const demoUser = AppUser(
    name: 'Pande Made Yonata Axel Eldrian',
    nrp: '5026241018',
    email: 'user@student.its.ac.id',
  );

  AppUser? _currentUser = demoUser;

  AppUser? get currentUser => _currentUser;

  /// Mengembalikan akun demo supaya fitur bisa dicoba berulang kali.
  void signInDemo() {
    _currentUser = demoUser;
  }

  Future<void> deleteAccount({required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    if (password != demoPassword) {
      throw const AuthException('Password salah. Coba lagi.');
    }

    _currentUser = null;
  }
}
