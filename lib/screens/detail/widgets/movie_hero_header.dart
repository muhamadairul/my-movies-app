import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/movie_detail_model.dart';
import '../../../widgets/star_rating_widget.dart';

/// Header hero dengan backdrop, poster, dan info film.
class MovieHeroHeader extends StatelessWidget {
  final MovieDetailModel movie;
  final bool isFavorited;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onBack;

  const MovieHeroHeader({
    super.key,
    required this.movie,
    required this.isFavorited,
    required this.onFavoriteToggle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Backdrop
          CachedNetworkImage(
            imageUrl: ApiConstants.backdropUrl(movie.backdropPath),
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: AppColors.surfaceCard),
            errorWidget: (_, __, ___) => Container(
              color: AppColors.surfaceCard,
              child: const Icon(Icons.image_not_supported, color: AppColors.textMuted),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0.3),
                  Colors.transparent,
                  AppColors.background,
                ],
                stops: const [0, 0.4, 1],
              ),
            ),
          ),
          // Top buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleButton(Icons.arrow_back_rounded, onBack),
                _buildCircleButton(Icons.share_outlined, () {}),
              ],
            ),
          ),
          // Bottom content
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Poster
                Hero(
                  tag: 'movie-poster-${movie.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: ApiConstants.posterUrl(movie.posterPath),
                      width: 110,
                      height: 165,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 110,
                        height: 165,
                        color: AppColors.surfaceCard,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: AppTextStyles.headingL,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateFormatter.getYear(movie.releaseDate),
                        style: AppTextStyles.bodyM,
                      ),
                      const SizedBox(height: 8),
                      // Genre chips
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: movie.genres.take(3).map((genre) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceCard.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              genre.name,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      StarRatingWidget(voteAverage: movie.voteAverage),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}