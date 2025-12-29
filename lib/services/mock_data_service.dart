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
      backdropPath: '/s3TBrRGB1iav7gFOCNx3H31MoES.jpg',
      overview:
          'Cobb, a skilled thief who commits corporate espionage by infiltrating the subconscious of his targets is offered a chance to regain his old life as payment for a task considered to be impossible: "inception", the implantation of another person\'s idea into a target\'s subconscious.',
      voteAverage: 8.4,
      releaseDate: '2010-07-16',
      mediaType: 'movie',
      genres: ['Action', 'Science Fiction', 'Adventure'],
      runtime: 148,
      trailerKey: 'YoHD9XEInc0',
      cast: [
        CastMember(name: 'Leonardo DiCaprio', character: 'Cobb', profilePath: '/wo2hJpn04vbtmh0B9utCFdsQhxM.jpg'),
        CastMember(name: 'Joseph Gordon-Levitt', character: 'Arthur', profilePath: '/z2FA8js799xqtfiFjBTicFYdfk.jpg'),
        CastMember(name: 'Elliot Page', character: 'Ariadne', profilePath: '/eCeFgzS8dYHnMfWQT0oQitCrsSz.jpg'),
        CastMember(name: 'Tom Hardy', character: 'Eames', profilePath: '/d81K0RH8UX7tZj49tZaQhZ9ewH.jpg'),
        CastMember(name: 'Marion Cotillard', character: 'Mal', profilePath: '/lBXAZycoTE4tjQbMkTrRepcXXrJ.jpg'),
      ],
    ),
    const Movie(
      id: 155,
      title: 'The Dark Knight',
      posterPath: '/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
      backdropPath: '/nMKdUUepR0i5zn0y1T4CsSB5chy.jpg',
      overview:
          'Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets.',
      voteAverage: 8.5,
      releaseDate: '2008-07-18',
      mediaType: 'movie',
      genres: ['Action', 'Crime', 'Drama'],
      runtime: 152,
      trailerKey: 'EXeTwQWrcwY',
      cast: [
        CastMember(name: 'Christian Bale', character: 'Bruce Wayne / Batman', profilePath: '/3qx2QFUbG6t6IlzR0F9k3Z6Yhf7.jpg'),
        CastMember(name: 'Heath Ledger', character: 'Joker', profilePath: '/5Y9HnYYa9jF4NunY9lSgJGjSe8E.jpg'),
        CastMember(name: 'Aaron Eckhart', character: 'Harvey Dent', profilePath: '/7QhFD0VhL6eFdTbmIqb1l7Y6FjX.jpg'),
      ],
    ),
    const Movie(
      id: 603,
      title: 'The Matrix',
      posterPath: '/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg',
      backdropPath: '/fNG7i7RqMErkcqhohV2a6cV1Ehy.jpg',
      overview:
          'Set in the 22nd century, The Matrix tells the story of a computer hacker who joins a group of underground insurgents fighting the vast and powerful computers who now rule the earth.',
      voteAverage: 8.2,
      releaseDate: '1999-03-31',
      mediaType: 'movie',
      genres: ['Action', 'Science Fiction'],
      runtime: 136,
      trailerKey: 'vKQi3bBA1y8',
      cast: [
        CastMember(name: 'Keanu Reeves', character: 'Neo', profilePath: '/4D0PpNI0kmP58hgrwGC3wCjxhnm.jpg'),
        CastMember(name: 'Laurence Fishburne', character: 'Morpheus', profilePath: '/8suOhUmPbfKqDQ17jQ1Gy0mI3P4.jpg'),
        CastMember(name: 'Carrie-Anne Moss', character: 'Trinity', profilePath: '/xD4jTA3KmVp5Rq3aHcymL9DUGjD.jpg'),
      ],
    ),
    const Movie(
      id: 157336,
      title: 'Interstellar',
      posterPath: '/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
      backdropPath: '/xu9zaAevzQ5nnrsXN6JcahLnG4i.jpg',
      overview:
          'The chronicles of a team of explorers who travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
      voteAverage: 8.4,
      releaseDate: '2014-11-07',
      mediaType: 'movie',
      genres: ['Adventure', 'Drama', 'Science Fiction'],
      runtime: 169,
      trailerKey: 'zSWdZVtXT7E',
      cast: [
        CastMember(name: 'Matthew McConaughey', character: 'Cooper', profilePath: '/sY2mwpafcwqyYS1sOySu1MENDse.jpg'),
        CastMember(name: 'Anne Hathaway', character: 'Brand', profilePath: '/tLelacFd4Z9u5KweB42JGDTPdpc.jpg'),
        CastMember(name: 'Jessica Chastain', character: 'Murphy', profilePath: '/lodMzLKSdrPcBry7LD4yO7zE8yL.jpg'),
      ],
    ),
    const Movie(
      id: 680,
      title: 'Pulp Fiction',
      posterPath: '/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg',
      backdropPath: '/4cDFJr4HnXN5AdPw4AKrmLlMWdO.jpg',
      overview:
          'A burger-loving hit man, his philosophical partner, and a drug-addled gangster\'s moll intertwine in this stylish black comedy.',
      voteAverage: 8.5,
      releaseDate: '1994-09-10',
      mediaType: 'movie',
      genres: ['Crime', 'Thriller'],
      runtime: 154,
      trailerKey: 's7EdQ4FqbhY',
      cast: [
        CastMember(name: 'John Travolta', character: 'Vincent Vega', profilePath: '/1SJAyuH7FNlNgAIkYf8fLbyzJNZ.jpg'),
        CastMember(name: 'Samuel L. Jackson', character: 'Jules Winnfield', profilePath: '/AiAYAqwpM5xmiFrAIeQvUXDCVvo.jpg'),
        CastMember(name: 'Uma Thurman', character: 'Mia Wallace', profilePath: '/xuxgPXyv6KjUHIM8cZaxx4ry25L.jpg'),
      ],
    ),
    const Movie(
      id: 13,
      title: 'Forrest Gump',
      posterPath: '/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg',
      backdropPath: '/7c9UVPPiTPltouxRVY6N9uUaROL.jpg',
      overview:
          'A man with a low IQ has accomplished great things in his life and been present during significant historic events—in each case, far exceeding what anyone imagined he could do.',
      voteAverage: 8.5,
      releaseDate: '1994-07-06',
      mediaType: 'movie',
      genres: ['Comedy', 'Drama', 'Romance'],
      runtime: 142,
      trailerKey: 'bLvqoHBptjg',
      cast: [
        CastMember(name: 'Tom Hanks', character: 'Forrest Gump', profilePath: '/eKF1sGJRrZJbfBG1KirPt1cfNd3.jpg'),
        CastMember(name: 'Robin Wright', character: 'Jenny Curran', profilePath: '/jbvwlJiPlWIwFsWGaLOb2UU9fNR.jpg'),
        CastMember(name: 'Gary Sinise', character: 'Lt. Dan Taylor', profilePath: '/2vdQ72R34xPHRcGDhCRUGOHPjF8.jpg'),
      ],
    ),
    const Movie(
      id: 278,
      title: 'The Shawshank Redemption',
      posterPath: '/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg',
      backdropPath: '/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg',
      overview:
          'Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden.',
      voteAverage: 8.7,
      releaseDate: '1994-09-23',
      mediaType: 'movie',
      genres: ['Drama', 'Crime'],
      runtime: 142,
      trailerKey: 'NmzuHjWmXOc',
      cast: [
        CastMember(name: 'Tim Robbins', character: 'Andy Dufresne', profilePath: '/hsCy8gSNydkit3jIxMkNvYaJOxI.jpg'),
        CastMember(name: 'Morgan Freeman', character: 'Ellis Boyd \'Red\' Redding', profilePath: '/jPsLqiYGSofU4s6BjrxnefMfabb.jpg'),
        CastMember(name: 'Bob Gunton', character: 'Warden Norton', profilePath: '/2BjRFAgNJfSOkHCjaJ97GxEQgAw.jpg'),
      ],
    ),
    const Movie(
      id: 238,
      title: 'The Godfather',
      posterPath: '/3bhkrj58Vtu7enYsRolD1fZdja1.jpg',
      backdropPath: '/tmU7GeKVybMWFButWEGl2M4GeiP.jpg',
      overview:
          'Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.',
      voteAverage: 8.7,
      releaseDate: '1972-03-14',
      mediaType: 'movie',
      genres: ['Drama', 'Crime'],
      runtime: 175,
      trailerKey: 'UaVTIH8mujA',
      cast: [
        CastMember(name: 'Marlon Brando', character: 'Don Vito Corleone', profilePath: '/fuTEPWsBje3RZCk6kFjIQAz9WQh.jpg'),
        CastMember(name: 'Al Pacino', character: 'Michael Corleone', profilePath: '/2dGBb1fOcNdZjtQToVPFxXjm4ke.jpg'),
        CastMember(name: 'James Caan', character: 'Sonny Corleone', profilePath: '/ls72wfQl8AhRVFe2ybqNnOTqr4.jpg'),
      ],
    ),
    const Movie(
      id: 550,
      title: 'Fight Club',
      posterPath: '/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg',
      backdropPath: '/hZkgoQYus5vegHoetLkCJzb17zJ.jpg',
      overview:
          'A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground "fight clubs" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.',
      voteAverage: 8.4,
      releaseDate: '1999-10-15',
      mediaType: 'movie',
      genres: ['Drama'],
      runtime: 139,
      trailerKey: 'BdJKm16Co6M',
      cast: [
        CastMember(name: 'Brad Pitt', character: 'Tyler Durden', profilePath: '/oTB9vGIBacH5aQNS0pUM74QSWuf.jpg'),
        CastMember(name: 'Edward Norton', character: 'The Narrator', profilePath: '/5XBzD5WuTyVQZeS4VI25z2moMeY.jpg'),
        CastMember(name: 'Helena Bonham Carter', character: 'Marla Singer', profilePath: '/DDeITcCpnBd0CkAIRPhggy9bt5.jpg'),
      ],
    ),
    const Movie(
      id: 496243,
      title: 'Parasite',
      posterPath: '/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',
      backdropPath: '/TU9NIjwzjoKPwQHoHshkFcQUCG.jpg',
      overview:
          'All unemployed, Ki-taek\'s family takes peculiar interest in the wealthy and glamorous Parks for their livelihood until they get entangled in an unexpected incident.',
      voteAverage: 8.5,
      releaseDate: '2019-05-30',
      mediaType: 'movie',
      genres: ['Comedy', 'Thriller', 'Drama'],
      runtime: 133,
      trailerKey: '5xH0HfJHsaY',
      cast: [
        CastMember(name: 'Song Kang-ho', character: 'Kim Ki-taek', profilePath: '/38yB0FHwvBDJ5x2pLsNZqx0jFkJ.jpg'),
        CastMember(name: 'Lee Sun-kyun', character: 'Park Dong-ik', profilePath: '/qM8R4JFV5JNByb3dLhHpQPUmk5H.jpg'),
        CastMember(name: 'Cho Yeo-jeong', character: 'Choi Yeon-gyo', profilePath: '/gwwkiSJFsFmMpzJ8hF6qoMqe8m.jpg'),
      ],
    ),
    const Movie(
      id: 1396,
      title: 'Breaking Bad',
      posterPath: '/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg',
      backdropPath: '/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg',
      overview:
          'A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing and selling methamphetamine in order to secure his family\'s future.',
      voteAverage: 8.9,
      releaseDate: '2008-01-20',
      mediaType: 'tv',
      genres: ['Drama', 'Crime'],
      runtime: 45,
      trailerKey: 'HhesaQXLuRY',
      cast: [
        CastMember(name: 'Bryan Cranston', character: 'Walter White', profilePath: '/7Jahy5LZX2Fo8fGJltMreAI49hC.jpg'),
        CastMember(name: 'Aaron Paul', character: 'Jesse Pinkman', profilePath: '/oTceEUb6A9Bg6DeUTJBTETUOEJu.jpg'),
        CastMember(name: 'Anna Gunn', character: 'Skyler White', profilePath: '/6yLKtfYFWbJp5HALvx0HSEmbzdv.jpg'),
      ],
    ),
    const Movie(
      id: 94605,
      title: 'Arcane',
      posterPath: '/fqldf2t8ztc9aiwn3k6mlX3tvRT.jpg',
      backdropPath: '/rkB4LyZHo1NHXFEDHl9vSD9r1lI.jpg',
      overview:
          'Amid the stark discord of twin cities Piltover and Zaun, two sisters fight on rival sides of a war between magic technologies and clashing convictions.',
      voteAverage: 8.8,
      releaseDate: '2021-11-06',
      mediaType: 'tv',
      genres: ['Animation', 'Sci-Fi & Fantasy', 'Action & Adventure'],
      runtime: 40,
      trailerKey: 'fXmAurh012s',
      cast: [
        CastMember(name: 'Hailee Steinfeld', character: 'Vi (voice)', profilePath: '/kfbQXqbwJttkyIYHNZ6SbqMzqFT.jpg'),
        CastMember(name: 'Ella Purnell', character: 'Jinx (voice)', profilePath: '/9y5EJPUX99U76gZJTFjLh2PNc9A.jpg'),
        CastMember(name: 'Katie Leung', character: 'Caitlyn (voice)', profilePath: '/cP2WREd0lZiTI0hPJWq6mPKNrR1.jpg'),
      ],
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
