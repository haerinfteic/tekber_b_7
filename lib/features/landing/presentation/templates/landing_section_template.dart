import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';

class LandingSectionTemplate extends StatelessWidget {
  final String? eyebrow;
  final String title;
  final String? subtitle;
  final Widget child;
  final Color backgroundColor;
  final bool centerHeader;

  const LandingSectionTemplate({
    super.key,
    this.eyebrow,
    required this.title,
    this.subtitle,
    required this.child,
    this.backgroundColor = Colors.transparent,
    this.centerHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final headerCross = centerHeader
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final textAlign = centerHeader ? TextAlign.center : TextAlign.start;

    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: AppTokens.s16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppTokens.maxContentWidth),
          child: Padding(
            padding: AppTokens.pagePadding,
            child: Column(
              crossAxisAlignment: headerCross,
              children: [
                if (eyebrow != null) ...[
                  Text(
                    eyebrow!.toUpperCase(),
                    textAlign: textAlign,
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s3),
                ],
                Text(title, textAlign: textAlign, style: textTheme.headlineMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: AppTokens.s3),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Text(
                      subtitle!,
                      textAlign: textAlign,
                      style: textTheme.bodyLarge,
                    ),
                  ),
                ],
                const SizedBox(height: AppTokens.s10),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
