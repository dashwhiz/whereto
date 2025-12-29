/// Movie or TV show model
/// Represents a searchable media item from TMDB
class Movie {
  final int id;                 // TMDB ID
  final String title;
  final String? posterPath;     // TMDB poster image path
  final String? overview;
  final double? voteAverage;
  final String? releaseDate;
  final String mediaType;       // "movie" or "tv"

  const Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.overview,
    this.voteAverage,
    this.releaseDate,
    required this.mediaType,
  });

  /// Get full poster URL for TMDB images
  /// Size options: w92, w154, w185, w342, w500, w780, original
  String? getPosterUrl({String size = 'w500'}) {
    if (posterPath == null) return null;
    return 'https://image.tmdb.org/t/p/$size$posterPath';
  }

  /// Get year from release date
  String? get year {
    if (releaseDate == null || releaseDate!.isEmpty) return null;
    return releaseDate!.split('-').first;
  }

  /// Display text for media type
  String get mediaTypeDisplay {
    return mediaType == 'tv' ? 'TV Show' : 'Movie';
  }

  /// Format rating as string
  String get ratingDisplay {
    if (voteAverage == null) return 'N/A';
    return voteAverage!.toStringAsFixed(1);
  }
}
