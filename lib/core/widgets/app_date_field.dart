import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_tokens.dart';

class AppDateField extends StatelessWidget {
  final String label;
  final String hint;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final Widget? prefixIcon;

  const AppDateField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.prefixIcon,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onPrimary: AppColors.white,
                ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppTokens.s2),
        InkWell(
          onTap: () => _pickDate(context),
          borderRadius: AppTokens.radiusSm,
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefixIcon,
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
            ),
            child: Text(
              value == null ? hint : _formatDate(value!),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: value == null
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
