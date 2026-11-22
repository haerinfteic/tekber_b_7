import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/landing/presentation/pages/landing_page.dart';

void main() {
  runApp(const FasorApp());
}

class FasorApp extends StatelessWidget {
  const FasorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FasorITS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LandingPage(),
    );
  }
}
