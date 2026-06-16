import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/constants/api_constants.dart';
import '../core/utils/rating_helper.dart';
import 'shimmer_card.dart';

/// Card film untuk horizontal list dengan poster dan info rating.
class MovieCard extends StatelessWidget {
  final String? posterPath;
  final String title;
  final double rating;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final bool isFavorited;

  const MovieCard({
    super.key,
    required this.posterPath,
    required this.title,
    required this.rating,
    required this.onTap,
    required this.onFavoriteTap,
    required this.isFavorited,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: ApiConstants.posterUrl(posterPath),
                    width: 130,
                    height: 195,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const ShimmerCard(width: 130, height: 195),
                    errorWidget: (context, url, error) => Container(
                      width: 130,
                      height: 195,
                      color: AppColors.surfaceCard,
                      child: const Icon(Icons.movie, color: AppColors.textMuted),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey(isFavorited),
                          color: isFavorited ? AppColors.accentGold : Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            // Rating
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 14),
                const SizedBox(width: 4),
                Text(
                  RatingHelper.format(rating),
                  style: AppTextStyles.ratingNum,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
