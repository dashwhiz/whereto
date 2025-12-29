import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/app_colors.dart';
import '../../../models/movie.dart';
import 'movie_card_item.dart';

class MovieListWidget extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie) onMovieTap;

  const MovieListWidget({
    super.key,
    required this.movies,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'noResults'.tr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'noResultsHint'.tr,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieCardItem(
          movie: movies[index],
          onTap: () => onMovieTap(movies[index]),
        );
      },
    );
  }
}
