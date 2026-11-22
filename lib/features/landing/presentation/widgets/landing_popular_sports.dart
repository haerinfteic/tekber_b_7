import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class LandingPopularSports extends StatelessWidget {
  const LandingPopularSports({super.key});

  @override
  Widget build(BuildContext context) {
    const sports = [
      _SportData(name: 'Badminton', icon: 'assets/icons/badminton.png'),
      _SportData(name: 'Futsal', icon: 'assets/icons/football.png'),
      _SportData(name: 'Basket', icon: 'assets/icons/basket.png'),
      _SportData(name: 'Tenis', icon: 'assets/icons/tennis.png'),
      _SportData(name: 'Voli', icon: 'assets/icons/voli.png'),
    ];

    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cabang Populer',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Temukan fasilitas olahraga yang paling sering dikunjungi',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.arrow_forward, size: 12, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < sports.length; i++) ...[
                  _SportCard(data: sports[i]),
                  if (i != sports.length - 1) const SizedBox(width: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SportData {
  final String name;
  final String icon;
  const _SportData({required this.name, required this.icon});
}

class _SportCard extends StatelessWidget {
  final _SportData data;
  const _SportCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              data.icon,
              width: 30,
              height: 30,
              errorBuilder: (_, _, _) => const Icon(Icons.sports, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data.name,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
