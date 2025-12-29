import 'dart:convert';
import '../models/movie.dart';
import '../models/watch_availability.dart';
import '../models/streaming_provider.dart';
import 'appwrite_service.dart';
import 'logging_service.dart';

/// TMDB service using Appwrite Functions
/// Provides movie search and streaming availability data
class TmdbService {
  static final TmdbService _instance = TmdbService._internal();
  factory TmdbService() => _instance;
  TmdbService._internal();

  final _appwrite = appwriteService;

  /// Search for movies and TV shows
  Future<List<Movie>> searchMovies(String query) async {
    try {
      log.info('Searching for: $query');

      final response = await _appwrite.searchMovies(query);
      final jsonString = response['data'] as String;
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      final results = data['results'] as List<dynamic>? ?? [];

      log.info('Found ${results.length} results');

      return results
          .where((item) {
            final mediaType = item['media_type'] as String?;
            return mediaType == 'movie' || mediaType == 'tv';
          })
          .map((item) => _parseMovie(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log.error('Search failed: $e');
      throw Exception('Failed to search movies: $e');
    }
  }

  /// Get watch providers for a movie/show
  Future<WatchAvailability?> getWatchProviders({
    required int movieId,
    required String mediaType,
    required String region,
  }) async {
    try {
      log.info('Getting watch providers for $mediaType $movieId in $region');

      final response = await _appwrite.getWatchProviders(
        movieId: movieId,
        mediaType: mediaType,
        region: region,
      );

      final jsonString = response['data'] as String;
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      final results = data['results'] as Map<String, dynamic>? ?? {};
      final regionData = results[region] as Map<String, dynamic>?;

      if (regionData == null) {
        log.info('No availability in $region');
        return null;
      }

      return _parseWatchAvailability(movieId, region, regionData);
    } catch (e) {
      log.error('Failed to get watch providers: $e');
      return null;
    }
  }

  /// Get detailed movie/TV show information
  Future<Movie?> getDetails({
    required int movieId,
    required String mediaType,
  }) async {
    try {
      log.info('Getting details for $mediaType $movieId');

      final response = await _appwrite.getDetails(
        movieId: movieId,
        mediaType: mediaType,
      );

      final jsonString = response['data'] as String;
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      return _parseMovieDetails(data, mediaType);
    } catch (e) {
      log.error('Failed to get movie details: $e');
      return null;
    }
  }

  /// Parse basic movie from search results
  Movie _parseMovie(Map<String, dynamic> json) {
    final mediaType = json['media_type'] as String? ?? 'movie';

    return Movie(
      id: json['id'] as int,
      title: json['title'] as String? ?? json['name'] as String? ?? 'Unknown',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      releaseDate: json['release_date'] as String? ?? json['first_air_date'] as String?,
      mediaType: mediaType,
    );
  }

  /// Parse detailed movie information with cast, genres, etc.
  Movie _parseMovieDetails(Map<String, dynamic> json, String mediaType) {
    // Parse genres
    final genresList = json['genres'] as List<dynamic>? ?? [];
    final genres = genresList
        .map((g) => (g as Map<String, dynamic>)['name'] as String)
        .toList();

    // Parse cast
    final credits = json['credits'] as Map<String, dynamic>?;
    final castList = credits?['cast'] as List<dynamic>? ?? [];
    final cast = castList
        .take(5)
        .map((c) => CastMember(
              name: (c as Map<String, dynamic>)['name'] as String,
              character: c['character'] as String? ?? '',
              profilePath: c['profile_path'] as String?,
            ))
        .toList();

    // Parse trailer
    final videos = json['videos'] as Map<String, dynamic>?;
    final videosList = videos?['results'] as List<dynamic>? ?? [];
    final trailer = videosList.firstWhere(
      (v) => (v as Map<String, dynamic>)['type'] == 'Trailer' && v['site'] == 'YouTube',
      orElse: () => null,
    );
    final trailerKey = trailer != null ? (trailer as Map<String, dynamic>)['key'] as String? : null;

    return Movie(
      id: json['id'] as int,
      title: json['title'] as String? ?? json['name'] as String? ?? 'Unknown',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      releaseDate: json['release_date'] as String? ?? json['first_air_date'] as String?,
      mediaType: mediaType,
      genres: genres,
      runtime: json['runtime'] as int? ?? json['episode_run_time']?[0] as int?,
      trailerKey: trailerKey,
      cast: cast,
    );
  }

  /// Parse watch availability from TMDB response
  WatchAvailability _parseWatchAvailability(
    int movieId,
    String region,
    Map<String, dynamic> json,
  ) {
    return WatchAvailability(
      movieId: movieId,
      countryCode: region,
      flatrate: _parseProviders(json['flatrate'] as List<dynamic>?),
      rent: _parseProviders(json['rent'] as List<dynamic>?),
      buy: _parseProviders(json['buy'] as List<dynamic>?),
      lastUpdated: DateTime.now(),
    );
  }

  /// Parse streaming providers list
  List<StreamingProvider> _parseProviders(List<dynamic>? providers) {
    if (providers == null) return [];

    return providers
        .map((p) => StreamingProvider(
              providerId: (p as Map<String, dynamic>)['provider_id'] as int,
              providerName: p['provider_name'] as String,
              logoPath: p['logo_path'] as String? ?? '',
              type: 'flatrate',
            ))
        .toList();
  }
}

/// Global instance
final tmdbService = TmdbService();
