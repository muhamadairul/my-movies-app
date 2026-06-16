import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/genre_model.dart';

/// Horizontal scrollable genre chips untuk filter.
class GenreChipRow extends StatelessWidget {
  final List<GenreModel> genres;
  final GenreModel? selectedGenre;
  final Function(GenreModel?) onGenreSelected;

  const GenreChipRow({
    super.key,
    required this.genres,
    required this.selectedGenre,
    required this.onGenreSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: genres.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildChip(
              label: 'Semua',
              isSelected: selectedGenre == null,
              onTap: () => onGenreSelected(null),
            );
          }
          final genre = genres[index - 1];
          return _buildChip(
            label: genre.name,
            isSelected: selectedGenre?.id == genre.id,
            onTap: () => onGenreSelected(genre),
          );
        },
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentGold : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.accentGold : AppColors.surfaceElevated,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.labelTag.copyWith(
              color: isSelected ? Colors.black : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
