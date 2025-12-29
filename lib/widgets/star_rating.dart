import 'package:flutter/material.dart';
import '../app/app_colors.dart';

class StarRating extends StatelessWidget {
  final double rating; // Out of 10 (TMDB format)
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 12,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    // Convert rating from 10 to 5 stars
    final normalizedRating = (rating / 10) * 5;
    final fullStars = normalizedRating.floor();
    final hasHalfStar = (normalizedRating - fullStars) >= 0.3;
    final emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    final activeStarColor = activeColor ?? const Color(0xFFFFB800);
    final inactiveStarColor =
        inactiveColor ?? AppColors.textTertiary.withValues(alpha: 0.3);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Full stars
        ...List.generate(
          fullStars,
          (index) => Icon(
            Icons.star_rounded,
            size: size,
            color: activeStarColor,
          ),
        ),

        // Half star
        if (hasHalfStar)
          Icon(
            Icons.star_half_rounded,
            size: size,
            color: activeStarColor,
          ),

        // Empty stars
        ...List.generate(
          emptyStars,
          (index) => Icon(
            Icons.star_outline_rounded,
            size: size,
            color: inactiveStarColor,
          ),
        ),

        // Rating text
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: size * 0.9,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
