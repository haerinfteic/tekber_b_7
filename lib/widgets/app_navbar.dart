import 'package:flutter/material.dart';

import '../core/app_theme.dart';

/// Navbar atas. Di desain, halaman Sign In hanya menampilkan "Browse Facilities",
/// sedangkan Sign Up menampilkan "Browse Facilities", "Order History" dan tombol "Sign In".
class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  const AppNavbar({
    super.key,
    this.showOrderHistory = false,
    this.showSignInButton = false,
    this.onBrowseFacilities,
    this.onOrderHistory,
    this.onSignIn,
  });

  final bool showOrderHistory;
  final bool showSignInButton;
  final VoidCallback? onBrowseFacilities;
  final VoidCallback? onOrderHistory;
  final VoidCallback? onSignIn;

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo_fasorits.png',
            width: 44,
            height: 44,
            filterQuality: FilterQuality.high,
          ),
          const SizedBox(width: 16),
          const Text(
            'FasorITS',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          // FittedBox supaya tidak overflow di layar HP yang sempit.
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _NavLink('Browse Facilities', onBrowseFacilities),
                  if (showOrderHistory) ...[
                    const SizedBox(width: 24),
                    _NavLink('Order History', onOrderHistory),
                  ],
                  if (showSignInButton) ...[
                    const SizedBox(width: 24),
                    SizedBox(
                      height: 37,
                      width: 93,
                      child: FilledButton(
                        onPressed: onSignIn,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink(this.label, this.onTap);

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(color: AppColors.textBody, fontSize: 14),
      ),
    );
  }
}
