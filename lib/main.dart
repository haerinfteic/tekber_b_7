import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/account/account_screen.dart';
import 'screens/account/delete_account_screen.dart';
import 'screens/account/delete_success_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FasorITS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Sementara mulai dari Sign In. Nanti diganti sesuai alur (cek sesi Supabase).
      // Untuk mencoba fitur Hapus Akun, ganti sementara jadi AccountScreen.routeName.
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (_) => const SignInScreen(),
        SignUpScreen.routeName: (_) => const SignUpScreen(),
        LandingPage.routeName: (_) => const LandingPage(),
        AccountScreen.routeName: (_) => const AccountScreen(),
        DeleteAccountScreen.routeName: (_) => const DeleteAccountScreen(),
        DeleteSuccessScreen.routeName: (_) => const DeleteSuccessScreen(),
      },
    );
  }
}
