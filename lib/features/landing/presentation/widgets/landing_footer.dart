import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF131B2E),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  'assets/logos/logo_fasorits.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'FasorITS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Sistem terintegrasi untuk pemesanan fasilitas olahraga di ITS secara cepat, transparan, dan akurat.',
            style: TextStyle(
              fontSize: 11,
              height: 1.5,
              color: Color(0xFFB6C0D1),
            ),
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.12)),
          const SizedBox(height: 12),
          const Text(
            '© 2026 FasorITS. All rights reserved.',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFFB6C0D1),
            ),
          ),
        ],
      ),
    );
  }
}
