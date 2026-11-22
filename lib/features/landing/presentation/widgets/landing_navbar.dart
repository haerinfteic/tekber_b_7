import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class LandingNavbar extends StatelessWidget {
  const LandingNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/logos/logo_fasorits.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.sports, size: 18, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'FasorITS',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              height: 1.2,
            ),
          ),
          const Spacer(),
          _NavText(label: 'Browse Facilities', onTap: () {}),
          const SizedBox(width: 16),
          _NavText(label: 'Order History', onTap: () {}),
          const SizedBox(width: 12),
          Image.asset(
            'assets/icons/profile.png',
            width: 28,
            height: 28,
            errorBuilder: (_, _, _) => Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline, size: 16, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavText extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavText({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: AppColors.navText,
        ),
      ),
    );
  }
}
