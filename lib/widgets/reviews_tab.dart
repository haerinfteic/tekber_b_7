import 'package:flutter/material.dart';

import '../models/facility_detail.dart';
import '../theme/app_colors.dart';

/// Isi tab Ulasan: ringkasan rating, distribusi bintang, dan daftar ulasan.
class ReviewsTab extends StatelessWidget {
  const ReviewsTab({super.key, required this.facility, this.onSeeAll});

  final FacilityDetail facility;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RatingSummary(facility: facility),
        const SizedBox(height: 24),
        for (final review in facility.reviews) _ReviewItem(review: review),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: onSeeAll ?? () {},
            child: const Text(
              'Lihat Semua Ulasan',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingSummary extends StatelessWidget {
  const _RatingSummary({required this.facility});

  final FacilityDetail facility;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              Text(
                facility.rating.toString(),
                style: const TextStyle(
                  fontSize: 48,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              StarRating(rating: facility.rating, size: 20),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  '${facility.reviewCount} Ulasan',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          for (var star = 5; star >= 1; star--)
            _BreakdownRow(
              star: star,
              count: facility.ratingBreakdown[star] ?? 0,
              total: facility.reviewCount,
            ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.star,
    required this.count,
    required this.total,
  });

  final int star;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 11, color: AppColors.textPrimary);
    final fraction = total == 0 ? 0.0 : (count / total).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text('$star Bintang', style: style)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Container(height: 8, color: AppColors.primarySoft),
                  FractionallySizedBox(
                    widthFactor: fraction,
                    child: Container(height: 8, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 36,
            child: Text('$count', textAlign: TextAlign.right, style: style),
          ),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({required this.review});

  final FacilityReview review;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      review.author,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    review.timeAgo,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              StarRating(rating: review.rating.toDouble(), size: 18),
              const SizedBox(height: 8),
              Text(
                review.comment,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: AppColors.textBody,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}

/// Lima bintang biru: penuh, setengah, atau outline sesuai [rating].
class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating, this.size = 18});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            rating >= i + 1
                ? Icons.star
                : rating >= i + 0.5
                    ? Icons.star_half
                    : Icons.star_border,
            size: size,
            color: AppColors.primary,
          ),
      ],
    );
  }
}
