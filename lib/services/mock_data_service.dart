import '../models/movie.dart';
import '../models/streaming_provider.dart';
import '../models/watch_availability.dart';
import '../models/region.dart';

/// Mock data service for development
/// Simulates API responses with realistic TMDB data
/// Will be replaced with real Appwrite service in Phase 2
class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  /// Simulate network delay (500ms - 1s)
  Future<void> _simulateDelay() async {
    await Future.delayed(
      Duration(milliseconds: 500 + (DateTime.now().millisecond % 500)),
    );
  }

  /// Mock movie database
  static final List<Movie> _movies = [
    const Movie(
      id: 27205,
      title: 'Inception',
      posterPath: '/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg',
      overview:
          'Cobb, a skilled thief who commits corporate espionage by infiltrating the subconscious of his targets is offered a chance to regain his old life.',
      voteAverage: 8.4,
      releaseDate: '2010-07-16',
      mediaType: 'movie',
    ),
    const Movie(
      id: 155,
      title: 'The Dark Knight',
      posterPath: '/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
      overview:
          'Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations.',
      voteAverage: 8.5,
      releaseDate: '2008-07-18',
      mediaType: 'movie',
    ),
    const Movie(
      id: 603,
      title: 'The Matrix',
      posterPath: '/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg',
      overview:
          'Set in the 22nd century, The Matrix tells the story of a computer hacker who joins a group of underground insurgents fighting the vast and powerful computers who now rule the earth.',
      voteAverage: 8.2,
      releaseDate: '1999-03-31',
      mediaType: 'movie',
    ),
    const Movie(
      id: 157336,
      title: 'Interstellar',
      posterPath: '/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
      overview:
          'The chronicles of a team of explorers who travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
      voteAverage: 8.4,
      releaseDate: '2014-11-07',
      mediaType: 'movie',
    ),
    const Movie(
      id: 680,
      title: 'Pulp Fiction',
      posterPath: '/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg',
      overview:
          'A burger-loving hit man, his philosophical partner, and a drug-addled gangster\'s moll intertwine in this stylish black comedy.',
      voteAverage: 8.5,
      releaseDate: '1994-09-10',
      mediaType: 'movie',
    ),
    const Movie(
      id: 13,
      title: 'Forrest Gump',
      posterPath: '/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg',
      overview:
          'A man with a low IQ has accomplished great things in his life and been present during significant historic events.',
      voteAverage: 8.5,
      releaseDate: '1994-07-06',
      mediaType: 'movie',
    ),
    const Movie(
      id: 278,
      title: 'The Shawshank Redemption',
      posterPath: '/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg',
      overview:
          'Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life.',
      voteAverage: 8.7,
      releaseDate: '1994-09-23',
      mediaType: 'movie',
    ),
    const Movie(
      id: 238,
      title: 'The Godfather',
      posterPath: '/3bhkrj58Vtu7enYsRolD1fZdja1.jpg',
      overview:
          'Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family.',
      voteAverage: 8.7,
      releaseDate: '1972-03-14',
      mediaType: 'movie',
    ),
    const Movie(
      id: 550,
      title: 'Fight Club',
      posterPath: '/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg',
      overview:
          'A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a new form of therapy.',
      voteAverage: 8.4,
      releaseDate: '1999-10-15',
      mediaType: 'movie',
    ),
    const Movie(
      id: 496243,
      title: 'Parasite',
      posterPath: '/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',
      overview:
          'All unemployed, Ki-taek\'s family takes peculiar interest in the wealthy and glamorous Parks for their livelihood.',
      voteAverage: 8.5,
      releaseDate: '2019-05-30',
      mediaType: 'movie',
    ),
    const Movie(
      id: 1396,
      title: 'Breaking Bad',
      posterPath: '/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg',
      overview:
          'A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing and selling methamphetamine.',
      voteAverage: 8.9,
      releaseDate: '2008-01-20',
      mediaType: 'tv',
    ),
    const Movie(
      id: 94605,
      title: 'Arcane',
      posterPath: '/fqldf2t8ztc9aiwn3k6mlX3tvRT.jpg',
      overview:
          'Amid the stark discord of twin cities Piltover and Zaun, two sisters fight on rival sides of a war between magic technologies and clashing convictions.',
      voteAverage: 8.8,
      releaseDate: '2021-11-06',
      mediaType: 'tv',
    ),
  ];

  /// Mock streaming providers
  static final List<StreamingProvider> _providers = [
    const StreamingProvider(
      providerId: 8,
      providerName: 'Netflix',
      logoPath: '/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg',
      type: 'flatrate',
    ),
    const StreamingProvider(
      providerId: 9,
      providerName: 'Amazon Prime Video',
      logoPath: '/emthp39XA2YScoYL1p0sdbAH2WA.jpg',
      type: 'flatrate',
    ),
    const StreamingProvider(
      providerId: 337,
      providerName: 'Disney Plus',
      logoPath: '/7rwgEs15tFwyR9NPQ5vpzxTj19Q.jpg',
      type: 'flatrate',
    ),
    const StreamingProvider(
      providerId: 2,
      providerName: 'Apple TV',
      logoPath: '/peURlLlr8jggOwK53fJ5wdQl05y.jpg',
      type: 'rent',
      price: '\$3.99',
    ),
    const StreamingProvider(
      providerId: 3,
      providerName: 'Google Play Movies',
      logoPath: '/tbEdFQDwx5LEVr8WpSeXQSIirVq.jpg',
      type: 'rent',
      price: '\$2.99',
    ),
    const StreamingProvider(
      providerId: 384,
      providerName: 'HBO Max',
      logoPath: '/Ajqyt5aNxNGjmF9uOfxArGrdf3X.jpg',
      type: 'flatrate',
    ),
  ];

  /// Mock availability data (movieId + region → availability)
  final Map<String, WatchAvailability> _availabilityCache = {
    // Inception - US
    '27205_US': WatchAvailability(
      movieId: 27205,
      countryCode: 'US',
      flatrate: [_providers[0]], // Netflix
      rent: [
        _providers[3].copyWith(price: '\$3.99'), // Apple TV
        _providers[4].copyWith(price: '\$2.99'), // Google Play
      ],
      buy: [
        _providers[3].copyWith(price: '\$14.99'), // Apple TV
      ],
      lastUpdated: DateTime.now(),
    ),
    // Inception - DE
    '27205_DE': WatchAvailability(
      movieId: 27205,
      countryCode: 'DE',
      flatrate: [_providers[1]], // Prime Video
      rent: [],
      buy: [],
      lastUpdated: DateTime.now(),
    ),
    // The Dark Knight - US
    '155_US': WatchAvailability(
      movieId: 155,
      countryCode: 'US',
      flatrate: [_providers[5]], // HBO Max
      rent: [_providers[3].copyWith(price: '\$3.99')],
      buy: [_providers[3].copyWith(price: '\$12.99')],
      lastUpdated: DateTime.now(),
    ),
    // The Matrix - US
    '603_US': WatchAvailability(
      movieId: 603,
      countryCode: 'US',
      flatrate: [_providers[0], _providers[5]], // Netflix + HBO Max
      rent: [],
      buy: [],
      lastUpdated: DateTime.now(),
    ),
    // Interstellar - US
    '157336_US': WatchAvailability(
      movieId: 157336,
      countryCode: 'US',
      flatrate: [_providers[1]], // Prime Video
      rent: [_providers[3].copyWith(price: '\$3.99')],
      buy: [],
      lastUpdated: DateTime.now(),
    ),
    // Pulp Fiction - US
    '680_US': WatchAvailability(
      movieId: 680,
      countryCode: 'US',
      flatrate: [],
      rent: [
        _providers[3].copyWith(price: '\$3.99'),
        _providers[4].copyWith(price: '\$2.99'),
      ],
      buy: [_providers[3].copyWith(price: '\$9.99')],
      lastUpdated: DateTime.now(),
    ),
    // Breaking Bad - US
    '1396_US': WatchAvailability(
      movieId: 1396,
      countryCode: 'US',
      flatrate: [_providers[0]], // Netflix
      rent: [],
      buy: [],
      lastUpdated: DateTime.now(),
    ),
    // Arcane - US
    '94605_US': WatchAvailability(
      movieId: 94605,
      countryCode: 'US',
      flatrate: [_providers[0]], // Netflix
      rent: [],
      buy: [],
      lastUpdated: DateTime.now(),
    ),
  };

  /// Search movies by title
  Future<List<Movie>> searchMovies(String query) async {
    await _simulateDelay();

    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return _movies.where((movie) {
      return movie.title.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get watch availability for a movie in a specific region
  Future<WatchAvailability?> getAvailability(
    int movieId,
    String countryCode,
  ) async {
    await _simulateDelay();

    final key = '${movieId}_$countryCode';
    return _availabilityCache[key];
  }

  /// Get all available regions
  List<Region> getAvailableRegions() {
    return Region.all;
  }

  /// Get popular regions
  List<Region> getPopularRegions() {
    return Region.popular;
  }
}

/// Extension to copy StreamingProvider with modifications
extension StreamingProviderCopy on StreamingProvider {
  StreamingProvider copyWith({
    int? providerId,
    String? providerName,
    String? logoPath,
    String? type,
    String? price,
  }) {
    return StreamingProvider(
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      logoPath: logoPath ?? this.logoPath,
      type: type ?? this.type,
      price: price ?? this.price,
    );
  }
}

/// Global instance
final mockDataService = MockDataService();
