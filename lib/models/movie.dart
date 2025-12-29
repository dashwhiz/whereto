/// Movie or TV show model
/// Represents a searchable media item from TMDB
class Movie {
  final int id;                 // TMDB ID
  final String title;
  final String? posterPath;     // TMDB poster image path
  final String? backdropPath;   // TMDB backdrop image path
  final String? overview;
  final double? voteAverage;
  final String? releaseDate;
  final String mediaType;       // "movie" or "tv"
  final List<String> genres;    // Genre names
  final int? runtime;            // Runtime in minutes
  final String? trailerKey;      // YouTube trailer key
  final List<CastMember> cast;   // Cast members

  const Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.voteAverage,
    this.releaseDate,
    required this.mediaType,
    this.genres = const [],
    this.runtime,
    this.trailerKey,
    this.cast = const [],
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

  /// Get full backdrop URL for TMDB images
  String? getBackdropUrl({String size = 'w780'}) {
    if (backdropPath == null) return null;
    return 'https://image.tmdb.org/t/p/$size$backdropPath';
  }

  /// Format runtime as "Xh Ym"
  String? get runtimeDisplay {
    if (runtime == null) return null;
    final hours = runtime! ~/ 60;
    final minutes = runtime! % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  /// Get YouTube trailer URL
  String? get trailerUrl {
    if (trailerKey == null) return null;
    return 'https://www.youtube.com/watch?v=$trailerKey';
  }
}

/// Cast member model
class CastMember {
  final String name;
  final String character;
  final String? profilePath;

  const CastMember({
    required this.name,
    required this.character,
    this.profilePath,
  });

  /// Get full profile image URL
  String? getProfileUrl({String size = 'w185'}) {
    if (profilePath == null) return null;
    return 'https://image.tmdb.org/t/p/$size$profilePath';
  }
}
