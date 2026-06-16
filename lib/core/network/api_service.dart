import 'package:dio/dio.dart';
import 'dio_client.dart';
import '../constants/api_constants.dart';

/// Service layer untuk semua API call ke TMDb.
/// Setiap method mengembalikan Response yang bisa diparsing di repository.
class ApiService {
  final Dio _dio = DioClient().dio;

  /// Ambil film yang sedang tayang (Now Playing)
  Future<Response> getNowPlaying() async {
    return await _dio.get(ApiConstants.nowPlaying);
  }

  /// Ambil film populer
  Future<Response> getPopular() async {
    return await _dio.get(ApiConstants.popular);
  }

  /// Ambil film dengan rating tertinggi
  Future<Response> getTopRated() async {
    return await _dio.get(ApiConstants.topRated);
  }

  /// Ambil film yang akan datang
  Future<Response> getUpcoming() async {
    return await _dio.get(ApiConstants.upcoming);
  }

  /// Ambil detail film berdasarkan ID
  Future<Response> getMovieDetail(int movieId) async {
    return await _dio.get(ApiConstants.movieDetail(movieId));
  }

  /// Ambil cast/crew film
  Future<Response> getMovieCredits(int movieId) async {
    return await _dio.get(ApiConstants.movieCredits(movieId));
  }

  /// Ambil video/trailer film
  Future<Response> getMovieVideos(int movieId) async {
    return await _dio.get(ApiConstants.movieVideos(movieId));
  }

  /// Cari film berdasarkan query
  Future<Response> searchMovies(String query) async {
    return await _dio.get(ApiConstants.searchMovie(query));
  }

  /// Ambil daftar genre film
  Future<Response> getGenreList() async {
    return await _dio.get(ApiConstants.genreList);
  }
}
