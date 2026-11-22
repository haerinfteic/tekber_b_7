import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Navbar atas: logo FasorITS, "Browse Facilities", "Order History", avatar.
class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  const AppNavbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 0,
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              const _Logo(size: 36),
              const SizedBox(width: 8),
              const Text(
                'FasorITS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      _NavLink('Browse Facilities', onTap: () {}),
                      const SizedBox(width: 20),
                      _NavLink('Order History', onTap: () {}),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.account_circle,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink(this.label, {required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_fasorits.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.footerBackground,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _Logo(size: 36),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'FasorITS',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'A centralized platform for sports facility management '
                      'at Institut Teknologi Sepuluh Nopember. Promoting a '
                      'healthy and active campus lifestyle.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.textBody,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                flex: 3,
                child: _FooterColumn(
                  title: 'QUICK LINKS',
                  links: ['Browse Facilities', 'Membership', 'Support'],
                ),
              ),
              const Expanded(
                flex: 3,
                child: _FooterColumn(
                  title: 'LEGAL',
                  links: ['Privacy Policy', 'Terms of Service'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '© 2026 FasorITS Sports Facilities. All rights reserved.',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.links});

  final String title;
  final List<String> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        for (final link in links)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              link,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
      ],
    );
  }
}
