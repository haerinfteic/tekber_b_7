import 'package:flutter/material.dart';

import '../core/app_theme.dart';

/// Top app bar FasorITS: logo di kiri, aksi teks (mis. "Kembali") di kanan.
AppBar fasorAppBar({String? actionLabel, VoidCallback? onAction}) {
  return AppBar(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    automaticallyImplyLeading: false,
    toolbarHeight: 64,
    titleSpacing: 16,
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo_fasorits.png',
          width: 32,
          height: 32,
          filterQuality: FilterQuality.high,
        ),
        const SizedBox(width: 8),
        const Text(
          'FasorITS',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    ),
    actions: [
      if (actionLabel != null)
        TextButton(
          onPressed: onAction,
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textBody,
            ),
          ),
        ),
      const SizedBox(width: 8),
    ],
    bottom: const PreferredSize(
      preferredSize: Size.fromHeight(1),
      child: Divider(height: 1, thickness: 1, color: AppColors.divider),
    ),
  );
}
