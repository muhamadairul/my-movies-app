import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider untuk mengelola state autentikasi pengguna.
/// Menggunakan SharedPreferences untuk persistensi session.
class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userEmail = '';
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  String get userEmail => _userEmail;
  bool get isLoading => _isLoading;

  /// Cek status login saat aplikasi startup
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    _userEmail = prefs.getString('user_email') ?? '';
    notifyListeners();
  }

  /// Proses login dengan validasi lokal
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi delay network
    await Future.delayed(const Duration(milliseconds: 800));

    if (email == 'user@mymovies.com' && password == 'movie123') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_email', email);
      _isLoggedIn = true;
      _userEmail = email;
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Logout dan hapus session
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    _userEmail = '';
    notifyListeners();
  }
}
