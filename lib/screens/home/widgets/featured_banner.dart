import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/rating_helper.dart';
import '../../../data/models/movie_model.dart';
import '../../../providers/favorite_provider.dart';
import 'package:provider/provider.dart';

/// Banner hero carousel untuk film yang sedang tayang.
class FeaturedBanner extends StatelessWidget {
  final List<MovieModel> movies;
  final PageController pageController;
  final Function(int) onPageChanged;
  final int currentPage;
  final Function(MovieModel) onMovieTap;

  const FeaturedBanner({
    super.key,
    required this.movies,
    required this.pageController,
    required this.onPageChanged,
    required this.currentPage,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: movies.length.clamp(0, 5),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return _buildBannerItem(context, movie);
            },
          ),
        ),
        const SizedBox(height: 12),
        // Page indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            movies.length.clamp(0, 5),
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: currentPage == index ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: currentPage == index
                    ? AppColors.accentGold
                    : AppColors.textMuted.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerItem(BuildContext context, MovieModel movie) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final isFav = favoriteProvider.isFavorited(movie.id);

    return GestureDetector(
      onTap: () => onMovieTap(movie),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Backdrop image
          CachedNetworkImage(
            imageUrl: ApiConstants.backdropUrl(movie.backdropPath),
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.surfaceCard,
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.surfaceCard,
              child: const Icon(Icons.image_not_supported, color: AppColors.textMuted),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.heroGradient,
            ),
          ),
          // Content
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: AppTextStyles.headingL,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      RatingHelper.format(movie.voteAverage),
                      style: AppTextStyles.ratingNum.copyWith(fontSize: 16),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentGoldSoft,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Sedang Tayang',
                        style: AppTextStyles.labelTag.copyWith(
                          color: AppColors.accentGold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => onMovieTap(movie),
                        icon: const Icon(Icons.play_arrow_rounded, size: 20),
                        label: const Text('Tonton Sekarang'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGold,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => favoriteProvider.toggleFavorite(movie),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            key: ValueKey(isFav),
                            color: isFav ? AppColors.accentGold : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
