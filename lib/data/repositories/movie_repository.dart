import '../../core/network/api_service.dart';
import '../models/movie_model.dart';
import '../models/movie_detail_model.dart';
import '../models/cast_model.dart';
import '../models/genre_model.dart';

/// Repository layer yang menjembatani API service dengan provider.
/// Menangani parsing data dan error handling.
class MovieRepository {
  final ApiService _apiService = ApiService();

  /// Ambil film yang sedang tayang
  Future<List<MovieModel>> getNowPlaying() async {
    final response = await _apiService.getNowPlaying();
    final results = response.data['results'] as List<dynamic>;
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  /// Ambil film populer
  Future<List<MovieModel>> getPopular() async {
    final response = await _apiService.getPopular();
    final results = response.data['results'] as List<dynamic>;
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  /// Ambil film top rated
  Future<List<MovieModel>> getTopRated() async {
    final response = await _apiService.getTopRated();
    final results = response.data['results'] as List<dynamic>;
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  /// Ambil film upcoming
  Future<List<MovieModel>> getUpcoming() async {
    final response = await _apiService.getUpcoming();
    final results = response.data['results'] as List<dynamic>;
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  /// Ambil detail film
  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    final response = await _apiService.getMovieDetail(movieId);
    return MovieDetailModel.fromJson(response.data);
  }

  /// Ambil cast film
  Future<List<CastModel>> getMovieCredits(int movieId) async {
    final response = await _apiService.getMovieCredits(movieId);
    final cast = response.data['cast'] as List<dynamic>;
    return cast.map((json) => CastModel.fromJson(json)).toList();
  }

  /// Ambil video/trailer film
  Future<String?> getMovieTrailerKey(int movieId) async {
    final response = await _apiService.getMovieVideos(movieId);
    final videos = response.data['results'] as List<dynamic>;
    final trailer = videos.firstWhere(
      (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
      orElse: () => null,
    );
    return trailer?['key']?.toString();
  }

  /// Cari film
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await _apiService.searchMovies(query);
    final results = response.data['results'] as List<dynamic>;
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  /// Ambil daftar genre
  Future<List<GenreModel>> getGenreList() async {
    final response = await _apiService.getGenreList();
    final genres = response.data['genres'] as List<dynamic>;
    return genres.map((json) => GenreModel.fromJson(json)).toList();
  }
}
