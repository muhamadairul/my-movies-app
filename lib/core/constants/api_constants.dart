/// Constants untuk API The Movie Database (TMDb)
/// Semua URL, key, dan konfigurasi API terpusat di sini.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/';
  static const String posterSize = 'w500';
  static const String backdropSize = 'w1280';
  static const String profileSize = 'w185';

  static const String apiKey = '236d47c9c75082028f2f83ead59bae7e';
  static const String bearerToken = 
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMzZkNDdjOWM3NTA4MjAyOGYyZjgzZWFkNTliYWU3ZSIsIm5iZiI6MTc4MTYyMjYyMC45NjMsInN1YiI6IjZhMzE2NzVjNTgzNzY4ZjQ3YjBiNWMyYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.K_-a3G8Vjt6i24AjVZsW-Zv9e4eXrS4Tux_OORT_mHE';

  static Map<String, String> get headers => {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      };

  // Endpoints
  static String get nowPlaying => '$baseUrl/movie/now_playing?language=id-ID&page=1';
  static String get popular => '$baseUrl/movie/popular?language=id-ID&page=1';
  static String get topRated => '$baseUrl/movie/top_rated?language=id-ID&page=1';
  static String get upcoming => '$baseUrl/movie/upcoming?language=id-ID&page=1';
  static String get genreList => '$baseUrl/genre/movie/list?language=id';

  static String movieDetail(int movieId) => 
      '$baseUrl/movie/$movieId?language=id-ID';
  static String movieCredits(int movieId) => 
      '$baseUrl/movie/$movieId/credits';
  static String movieVideos(int movieId) => 
      '$baseUrl/movie/$movieId/videos';
  static String searchMovie(String query) => 
      '$baseUrl/search/movie?query=${Uri.encodeComponent(query)}&language=id-ID&page=1';

  static String posterUrl(String? path) =>
      path != null ? '$imageBaseUrl$posterSize$path' : '';
  static String backdropUrl(String? path) =>
      path != null ? '$imageBaseUrl$backdropSize$path' : '';
  static String profileUrl(String? path) =>
      path != null ? '$imageBaseUrl$profileSize$path' : '';
}
