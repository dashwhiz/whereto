import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart' as models;

/// Appwrite service for backend communication
/// Handles TMDB API calls through serverless functions
class AppwriteService {
  static const String _endpoint = 'https://fra.cloud.appwrite.io/v1';
  static const String _projectId = '6952d8d5003a0e732d08';

  static final AppwriteService _instance = AppwriteService._internal();
  factory AppwriteService() => _instance;
  AppwriteService._internal();

  late final Client _client;
  late final Functions _functions;

  /// Initialize Appwrite client
  void init() {
    _client = Client()
      ..setEndpoint(_endpoint)
      ..setProject(_projectId)
      ..setSelfSigned(status: true); // For development

    _functions = Functions(_client);
  }

  /// Search movies/TV shows via TMDB
  /// Calls Appwrite Function: tmdb-search
  Future<Map<String, dynamic>> searchMovies(String query) async {
    try {
      final execution = await _functions.createExecution(
        functionId: 'tmdb-search',
        body: query, // Just pass the query string
      );

      if (execution.responseStatusCode != 200) {
        throw Exception('Search failed: ${execution.errors}');
      }

      // Parse JSON response
      return _parseResponse(execution.responseBody);
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }

  /// Get watch providers for a movie/show
  /// Calls Appwrite Function: tmdb-watch-providers
  Future<Map<String, dynamic>> getWatchProviders({
    required int movieId,
    required String mediaType,
    required String region,
  }) async {
    try {
      final execution = await _functions.createExecution(
        functionId: 'tmdb-watch-providers',
        body: '$movieId|$mediaType|$region', // Simple pipe-separated format
      );

      if (execution.responseStatusCode != 200) {
        throw Exception('Failed to get watch providers: ${execution.errors}');
      }

      return _parseResponse(execution.responseBody);
    } catch (e) {
      throw Exception('Failed to get watch providers: $e');
    }
  }

  /// Get detailed movie/TV show information
  /// Calls Appwrite Function: tmdb-details
  Future<Map<String, dynamic>> getDetails({
    required int movieId,
    required String mediaType,
  }) async {
    try {
      final execution = await _functions.createExecution(
        functionId: 'tmdb-details',
        body: '$movieId|$mediaType',
      );

      if (execution.responseStatusCode != 200) {
        throw Exception('Failed to get details: ${execution.errors}');
      }

      return _parseResponse(execution.responseBody);
    } catch (e) {
      throw Exception('Failed to get movie details: $e');
    }
  }

  /// Parse JSON response from Appwrite Function
  Map<String, dynamic> _parseResponse(String responseBody) {
    try {
      // Response should already be JSON
      if (responseBody.isEmpty) {
        throw Exception('Empty response from server');
      }

      // The response is already a JSON string, just return it as a map
      // Appwrite returns the function response as-is
      return {'data': responseBody};
    } catch (e) {
      throw Exception('Failed to parse response: $e');
    }
  }
}

/// Global instance
final appwriteService = AppwriteService();
