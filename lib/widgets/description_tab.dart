import 'package:flutter/material.dart';

import '../models/facility_detail.dart';
import '../theme/app_colors.dart';
import '../utils/format.dart';
import 'booking_card.dart';

/// Isi tab Deskripsi: teks, spesifikasi, kartu booking, dan Fasilitas Lainnya.
class DescriptionTab extends StatelessWidget {
  const DescriptionTab({super.key, required this.facility, this.onBook});

  final FacilityDetail facility;
  final void Function(DateTime date, int hour)? onBook;

  @override
  Widget build(BuildContext context) {
    final specs = [
      (Icons.straighten, 'Ukuran', facility.size),
      (Icons.groups_outlined, 'Kapasitas', facility.capacity),
      (Icons.lightbulb_outline, 'Penerangan', facility.lighting),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          facility.description,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: AppColors.textBody,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 24,
          runSpacing: 12,
          children: [
            for (final (icon, label, value) in specs)
              _SpecItem(icon: icon, label: label, value: value),
          ],
        ),
        const SizedBox(height: 20),
        BookingCard(
          pricePerHour: facility.pricePerHour,
          serviceFee: facility.serviceFee,
          onBook: onBook,
        ),
        const SizedBox(height: 32),
        const Divider(height: 1, color: AppColors.divider),
        const SizedBox(height: 24),
        const Text(
          'Fasilitas Lainnya',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _OtherFacilitiesGrid(items: facility.otherFacilities),
      ],
    );
  }
}

class _SpecItem extends StatelessWidget {
  const _SpecItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OtherFacilitiesGrid extends StatelessWidget {
  const _OtherFacilitiesGrid({required this.items});

  final List<OtherFacility> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i += 2) ...[
          if (i > 0) const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _OtherFacilityCard(item: items[i])),
                const SizedBox(width: 12),
                Expanded(
                  child: i + 1 < items.length
                      ? _OtherFacilityCard(item: items[i + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _OtherFacilityCard extends StatelessWidget {
  const _OtherFacilityCard({required this.item});

  final OtherFacility item;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 353 / 160,
            child: Image.asset(
              item.imageAsset,
              fit: BoxFit.cover,
              // Foto sumber punya area putih di bawah; ambil bagian atasnya.
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stack) =>
                  const ColoredBox(color: AppColors.primarySoft),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.venue,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${formatRupiah(item.pricePerHour)}/jam',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
