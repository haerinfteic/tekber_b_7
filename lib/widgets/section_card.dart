import 'package:flutter/material.dart';

import '../core/account_styles.dart';
import '../core/app_theme.dart';

/// Kartu putih berborder dengan header abu-abu, seperti kartu
/// "Payment Details" dan "Ringkasan Pesanan" di desain Hi-Fi.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.headerColor = AccountColors.cardHeader,
    this.borderColor = AppColors.cardBorder,
  });

  final String title;
  final Widget child;
  final Color headerColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: headerColor,
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Text(title, style: AccountText.sectionTitle),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}
