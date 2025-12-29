import 'dart:ui';
import 'package:flutter/material.dart';
import '../app/app_colors.dart';

class GenreChips extends StatelessWidget {
  final List<String> genres;
  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;

  const GenreChips({
    super.key,
    required this.genres,
    this.fontSize = 12,
    this.horizontalPadding = 12,
    this.verticalPadding = 6,
  });

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: genres.asMap().entries.map((entry) {
          final index = entry.key;
          final genre = entry.value;
          return Padding(
            padding: EdgeInsets.only(right: index < genres.length - 1 ? 8 : 0),
            child: _buildGenreChip(genre),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGenreChip(String genre) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.15),
                AppColors.primary.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Text(
            genre,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
