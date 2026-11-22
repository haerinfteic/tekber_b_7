import 'package:flutter/material.dart';


/// Warna dan tema FasorITS, diambil dari desain Figma (halaman Sign In / Sign Up).
class AppColors {
  AppColors._();

  static const primary = Color(0xFF0057BD);
  static const background = Color(0xFFF8F9FB);
  static const surface = Colors.white;

  static const textDark = Color(0xFF151B2B);
  static const textBody = Color(0xFF374151);
  static const textMuted = Color(0xFF4B5563);
  static const hint = Color(0xFF6B7280);

  static const cardBorder = Color(0xFFD9DBE8);
  static const inputBorder = Color(0xFFA9ACC0);
  static const divider = Color(0xFFD1D5DB);
  static const error = Color(0xFFB3261E);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Geist',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
  }
}

