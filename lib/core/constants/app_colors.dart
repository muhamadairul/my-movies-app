import 'package:flutter/material.dart';

/// Design System — Dark Cinema Theme
/// Tema gelap premium terinspirasi dari pengalaman bioskop.
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF0A0A0F);
  static const Color surfaceCard = Color(0xFF13131A);
  static const Color surfaceElevated = Color(0xFF1C1C28);

  // Accent — Cinema Gold
  static const Color accentGold = Color(0xFFFFBF00);
  static const Color accentGoldSoft = Color(0x26FFBF00);

  // Text
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFF9E9EAE);
  static const Color textMuted = Color(0xFF5A5A70);

  // Semantic
  static const Color success = Color(0xFF4CAF82);
  static const Color error = Color(0xFFE5534B);

  // Gradient utama untuk banner/header
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xFF0A0A0F)],
    stops: [0.3, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC0A0A0F)],
    stops: [0.5, 1.0],
  );
}
