import 'package:flutter/material.dart';

import 'app_theme.dart';

/// Warna tambahan untuk fitur akun (peringatan merah dan status sukses).
/// Warna utama tetap memakai AppColors di app_theme.dart.
class AccountColors {
  AccountColors._();

  static const cardHeader = Color(0xFFF1F5F9);
  static const dangerDark = Color(0xFF93000A);
  static const dangerSoft = Color(0xFFFFDAD6);
  static const dangerBorder = Color(0xFFFFB4AB);
  static const success = Color(0xFF1E8E3E);
  static const successSoft = Color(0xFFE6F4EA);
}

class AccountText {
  AccountText._();

  static const title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static const body = TextStyle(
    fontSize: 14,
    height: 1.4,
    color: AppColors.textMuted,
  );

  static const hint = TextStyle(
    fontSize: 14,
    color: AppColors.hint,
  );
}
