import 'package:flutter/material.dart';
import '../data/models/movie_model.dart';
import '../data/models/movie_detail_model.dart';
import '../data/models/cast_model.dart';
import '../data/models/genre_model.dart';
import '../data/repositories/movie_repository.dart';

/// Enum untuk state loading screen
enum ScreenState { initial, loading, loaded, error, empty }

/// Provider untuk mengelola data film dan state UI Home Screen.
class MovieProvider extends ChangeNotifier {
  final MovieRepository _repository = MovieRepository();

  // State
  ScreenState _state = ScreenState.initial;
  String _errorMessage = '';

  // Data
  List<MovieModel> _nowPlaying = [];
  List<MovieModel> _popular = [];
  List<MovieModel> _topRated = [];
  List<MovieModel> _upcoming = [];
  List<GenreModel> _genres = [];
  GenreModel? _selectedGenre;

  // Detail
  MovieDetailModel? _movieDetail;
  List<CastModel> _cast = [];
  String? _trailerKey;

  // Getters
  ScreenState get state => _state;
  String get errorMessage => _errorMessage;
  List<MovieModel> get nowPlaying => _nowPlaying;
  List<MovieModel> get popular => _popular;
  List<MovieModel> get topRated => _topRated;
  List<MovieModel> get upcoming => _upcoming;
  List<GenreModel> get genres => _genres;
  GenreModel? get selectedGenre => _selectedGenre;
  MovieDetailModel? get movieDetail => _movieDetail;
  List<CastModel> get cast => _cast;
  String? get trailerKey => _trailerKey;

  /// Ambil semua data untuk Home Screen
  Future<void> fetchHomeData() async {
    _state = ScreenState.loading;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getNowPlaying(),
        _repository.getPopular(),
        _repository.getTopRated(),
        _repository.getUpcoming(),
        _repository.getGenreList(),
      ]);

      _nowPlaying = results[0] as List<MovieModel>;
      _popular = results[1] as List<MovieModel>;
      _topRated = results[2] as List<MovieModel>;
      _upcoming = results[3] as List<MovieModel>;
      _genres = results[4] as List<GenreModel>;

      _state = ScreenState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = ScreenState.error;
      _errorMessage = 'Gagal memuat data film. Periksa koneksi internet Anda.';
    }
    notifyListeners();
  }

  /// Ambil detail film lengkap
  Future<void> fetchMovieDetail(int movieId) async {
    _state = ScreenState.loading;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getMovieDetail(movieId),
        _repository.getMovieCredits(movieId),
        _repository.getMovieTrailerKey(movieId),
      ]);

      _movieDetail = results[0] as MovieDetailModel;
      _cast = results[1] as List<CastModel>;
      _trailerKey = results[2] as String?;

      _state = ScreenState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = ScreenState.error;
      _errorMessage = 'Gagal memuat detail film.';
    }
    notifyListeners();
  }

  /// Pilih genre untuk filter
  void selectGenre(GenreModel? genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  /// Reset state detail
  void resetDetail() {
    _movieDetail = null;
    _cast = [];
    _trailerKey = null;
    _state = ScreenState.initial;
  }
}
