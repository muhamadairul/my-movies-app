import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/rating_helper.dart';
import '../../../data/models/movie_model.dart';

/// Card hasil pencarian dengan layout poster + info horizontal.
class SearchMovieCard extends StatelessWidget {
  final MovieModel movie;
  final bool isFavorited;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const SearchMovieCard({
    super.key,
    required this.movie,
    required this.isFavorited,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: ApiConstants.posterUrl(movie.posterPath),
                width: 80,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 80,
                  height: 120,
                  color: AppColors.surfaceElevated,
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 80,
                  height: 120,
                  color: AppColors.surfaceElevated,
                  child: const Icon(Icons.movie, color: AppColors.textMuted),
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
                    style: AppTextStyles.bodyL.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        RatingHelper.format(movie.voteAverage),
                        style: AppTextStyles.ratingNum,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        movie.releaseDate?.substring(0, 4) ?? 'N/A',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview ?? '',
                    style: AppTextStyles.caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Favorite button
            GestureDetector(
              onTap: onFavoriteTap,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(isFavorited),
                  color: isFavorited ? AppColors.accentGold : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}