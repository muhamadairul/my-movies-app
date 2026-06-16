import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/movie_model.dart';
import '../../../providers/favorite_provider.dart';
import '../../../widgets/movie_card.dart';
import 'package:provider/provider.dart';

/// Section horizontal scroll untuk daftar film.
class MovieHorizontalList extends StatelessWidget {
  final String title;
  final List<MovieModel> movies;
  final Function(MovieModel) onMovieTap;
  final VoidCallback? onSeeAll;

  const MovieHorizontalList({
    super.key,
    required this.title,
    required this.movies,
    required this.onMovieTap,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.headingM),
              if (onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
                  child: Text(
                    'Lihat Semua',
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.accentGold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Horizontal list
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(
                posterPath: movie.posterPath,
                title: movie.title,
                rating: movie.voteAverage,
                onTap: () => onMovieTap(movie),
                onFavoriteTap: () => favoriteProvider.toggleFavorite(movie),
                isFavorited: favoriteProvider.isFavorited(movie.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
