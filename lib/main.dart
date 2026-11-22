import 'package:flutter/material.dart';

import 'screens/facility_detail_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const FasorItsApp());
}

class FasorItsApp extends StatelessWidget {
  const FasorItsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FasorITS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      // Sementara langsung ke Detail Lapangan; ganti saat routing sudah ada.
      home: const FacilityDetailScreen(),
    );
  }
}
