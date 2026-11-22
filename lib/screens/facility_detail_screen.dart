import 'package:flutter/material.dart';

import '../models/facility_detail.dart';
import '../theme/app_colors.dart';
import '../widgets/app_navbar.dart';
import '../widgets/description_tab.dart';
import '../widgets/info_list_card.dart';
import '../widgets/reviews_tab.dart';

enum FacilityTab { deskripsi, fasilitas, peraturan, ulasan }

extension on FacilityTab {
  String get label => switch (this) {
        FacilityTab.deskripsi => 'Deskripsi',
        FacilityTab.fasilitas => 'Fasilitas',
        FacilityTab.peraturan => 'Peraturan',
        FacilityTab.ulasan => 'Ulasan',
      };
}

/// Screen Detail Lapangan dengan 4 tab: Deskripsi (booking), Fasilitas,
/// Peraturan, dan Ulasan.
class FacilityDetailScreen extends StatefulWidget {
  const FacilityDetailScreen({
    super.key,
    this.facility = FacilityDetail.stadionUtamaIts,
    this.initialTab = FacilityTab.deskripsi,
  });

  final FacilityDetail facility;
  final FacilityTab initialTab;

  @override
  State<FacilityDetailScreen> createState() => _FacilityDetailScreenState();
}

class _FacilityDetailScreenState extends State<FacilityDetailScreen> {
  late FacilityTab _tab = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    final facility = widget.facility;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppNavbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Breadcrumb(current: 'Stadion Utama ITS'),
                  const SizedBox(height: 4),
                  Text(
                    facility.name,
                    style: const TextStyle(
                      fontSize: 34,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _RatingLocationRow(facility: facility),
                  const SizedBox(height: 16),
                  _HeroImage(asset: facility.imageAsset),
                  const SizedBox(height: 24),
                  _FacilityTabBar(
                    selected: _tab,
                    onChanged: (tab) => setState(() => _tab = tab),
                  ),
                  const SizedBox(height: 24),
                  _TabContent(tab: _tab, facility: facility),
                  const SizedBox(height: 48),
                ],
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.current});

  final String current;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Facilities',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const Icon(Icons.chevron_right, size: 14, color: AppColors.textPrimary),
        Text(
          current,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _RatingLocationRow extends StatelessWidget {
  const _RatingLocationRow({required this.facility});

  final FacilityDetail facility;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 12, color: AppColors.textPrimary);
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 18, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              facility.rating.toString(),
              style: style.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 4),
            Text('(${facility.reviewCount} Ulasan)', style: style),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 18,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 2),
            Text(facility.location, style: style),
          ],
        ),
      ],
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: AspectRatio(
        aspectRatio: 575 / 325,
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          // Tampil placeholder jika file foto belum ditaruh di assets/images.
          errorBuilder: (context, error, stack) => const ColoredBox(
            color: AppColors.primarySoft,
            child: Center(
              child: Icon(
                Icons.stadium_outlined,
                size: 48,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FacilityTabBar extends StatelessWidget {
  const _FacilityTabBar({required this.selected, required this.onChanged});

  final FacilityTab selected;
  final ValueChanged<FacilityTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final tab in FacilityTab.values)
              _TabItem(
                label: tab.label,
                active: tab == selected,
                onTap: () => onChanged(tab),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({required this.tab, required this.facility});

  final FacilityTab tab;
  final FacilityDetail facility;

  @override
  Widget build(BuildContext context) {
    switch (tab) {
      case FacilityTab.fasilitas:
        return Column(
          children: [
            InfoListCard(
              icon: Icons.sports_soccer,
              title: 'Fasilitas Utama',
              items: facility.mainFacilities,
            ),
            const SizedBox(height: 16),
            InfoListCard(
              icon: Icons.apartment,
              title: 'Fasilitas Pendukung',
              items: facility.supportFacilities,
            ),
          ],
        );
      case FacilityTab.peraturan:
        return InfoListCard(
          icon: Icons.gavel,
          title: 'Peraturan',
          items: facility.rules,
        );
      case FacilityTab.deskripsi:
        return DescriptionTab(facility: facility);
      case FacilityTab.ulasan:
        return ReviewsTab(facility: facility);
    }
  }
}
