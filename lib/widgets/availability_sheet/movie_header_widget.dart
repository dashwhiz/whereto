import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../models/movie.dart';

class MovieHeaderWidget extends StatelessWidget {
  final Movie movie;

  const MovieHeaderWidget({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: movie.getPosterUrl() != null
              ? Image.network(
                  movie.getPosterUrl()!,
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPosterPlaceholder();
                  },
                )
              : _buildPosterPlaceholder(),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                '${movie.year ?? 'notAvailable'.tr} • ${movie.mediaTypeDisplay}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPosterPlaceholder() {
    return Container(
      width: 80,
      height: 120,
      color: AppColors.background,
      child: const Icon(Icons.movie, color: AppColors.textTertiary, size: 40),
    );
  }
}
