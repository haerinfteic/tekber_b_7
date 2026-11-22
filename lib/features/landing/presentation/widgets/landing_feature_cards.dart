import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class LandingFeatureCards extends StatelessWidget {
  const LandingFeatureCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 28),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _FeatureCard(
              iconAsset: 'assets/icons/thunder.png',
              title: 'Booking Instan',
              description: 'Pesan lapangan\nfavoritmu hanya dalam\nhitungan detik tanpa\nribet.',
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _FeatureCard(
              iconAsset: 'assets/icons/protection.png',
              title: 'Tanpa\nKonfirmasi\nAdmin',
              description: 'Sistem otomatis\nmemverifikasi\npembayaran dan slot\npesanan Anda secara\nlangsung.',
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _FeatureCard(
              iconAsset: 'assets/icons/clock.png',
              title: 'Real-time',
              description: 'Jadwal yang\nditampilkan selalu\nakurat sesuai dengan\nketersediaan lapangan\nterkini.',
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String iconAsset;
  final String title;
  final String description;

  const _FeatureCard({
    required this.iconAsset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              iconAsset,
              width: 20,
              height: 20,
              errorBuilder: (_, _, _) => const Icon(Icons.bolt, size: 20, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.25,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w400,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
