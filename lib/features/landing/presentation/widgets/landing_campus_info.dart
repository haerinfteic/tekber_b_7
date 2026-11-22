import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class LandingCampusInfo extends StatelessWidget {
  const LandingCampusInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.badgeBg,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    'INOVASI KAMPUS',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: AppColors.badgeText,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kelola Fasilitas\ndengan Standard\nProfessional',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'FasorITS memfasilitasi civitas akademika dan umum untuk mendapatkan akses ke fasilitas olahraga terbaik dengan transparansi penuh pada biaya dan jadwal penggunaan.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Expanded(
                      child: _StatItem(value: '15+', label: 'Fasilitas Tersedia'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _StatItem(value: '500+', label: 'Booking Mingguan'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/images/landing/stadion_its_2.png',
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 160,
                  color: AppColors.primarySoft,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image, color: AppColors.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
