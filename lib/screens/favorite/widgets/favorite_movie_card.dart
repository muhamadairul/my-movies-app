import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/rating_helper.dart';
import '../../../data/models/movie_model.dart';

/// Card film favorit dengan overlay gradient dan tombol hapus.
class FavoriteMovieCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const FavoriteMovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Poster
            CachedNetworkImage(
              imageUrl: ApiConstants.posterUrl(movie.posterPath),
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: AppColors.surfaceCard),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.surfaceCard,
                child: const Icon(Icons.movie, color: AppColors.textMuted),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.cardGradient,
              ),
            ),
            // Rating
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      RatingHelper.format(movie.voteAverage),
                      style: AppTextStyles.ratingNum.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            // Remove button
            Positioned(
              top: 8,
              left: 8,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
            // Title
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                movie.title,
                style: AppTextStyles.bodyM.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}