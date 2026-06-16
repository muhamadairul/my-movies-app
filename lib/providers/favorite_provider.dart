import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/movie_model.dart';

/// Provider untuk mengelola daftar film favorit pengguna.
/// Data disimpan secara lokal di SharedPreferences.
class FavoriteProvider extends ChangeNotifier {
  static const String _prefsKey = 'favorites';
  List<MovieModel> _favorites = [];

  List<MovieModel> get favorites => _favorites;
  int get count => _favorites.length;

  /// Load favorites dari local storage
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_prefsKey) ?? [];
    _favorites = jsonList
        .map((s) => MovieModel.fromJson(jsonDecode(s)))
        .toList();
    notifyListeners();
  }

  /// Simpan favorites ke local storage
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _favorites.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(_prefsKey, jsonList);
  }

  /// Cek apakah film sudah difavoritkan
  bool isFavorited(int movieId) {
    return _favorites.any((m) => m.id == movieId);
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(MovieModel movie) async {
    if (isFavorited(movie.id)) {
      _favorites.removeWhere((m) => m.id == movie.id);
    } else {
      _favorites.add(movie);
    }
    await _saveFavorites();
    notifyListeners();
  }

  /// Hapus dari favorit
  Future<void> removeFavorite(int movieId) async {
    _favorites.removeWhere((m) => m.id == movieId);
    await _saveFavorites();
    notifyListeners();
  }
}
