import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/movie_model.dart';
import '../data/repositories/movie_repository.dart';
import 'movie_provider.dart';

/// Provider untuk mengelola pencarian film dengan debounce.
class SearchProvider extends ChangeNotifier {
  final MovieRepository _repository = MovieRepository();
  Timer? _debounceTimer;

  ScreenState _state = ScreenState.initial;
  String _query = '';
  List<MovieModel> _results = [];
  String _errorMessage = '';

  ScreenState get state => _state;
  String get query => _query;
  List<MovieModel> get results => _results;
  String get errorMessage => _errorMessage;

  /// Update query dengan debounce 500ms
  void onSearchChanged(String value) {
    _query = value;
    _debounceTimer?.cancel();

    if (value.isEmpty) {
      _state = ScreenState.initial;
      _results = [];
      notifyListeners();
      return;
    }

    _state = ScreenState.loading;
    notifyListeners();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(value);
    });
  }

  /// Jalankan pencarian ke API
  Future<void> _performSearch(String query) async {
    try {
      _results = await _repository.searchMovies(query);
      _state = _results.isEmpty ? ScreenState.empty : ScreenState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = ScreenState.error;
      _errorMessage = 'Gagal mencari film. Coba lagi.';
    }
    notifyListeners();
  }

  /// Clear pencarian
  void clearSearch() {
    _debounceTimer?.cancel();
    _query = '';
    _results = [];
    _state = ScreenState.initial;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
