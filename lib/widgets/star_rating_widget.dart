import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/rating_helper.dart';

/// Widget bintang rating dengan angka.
class StarRatingWidget extends StatelessWidget {
  final double? voteAverage;
  final double starSize;
  final bool showNumber;

  const StarRatingWidget({
    super.key,
    required this.voteAverage,
    this.starSize = 14,
    this.showNumber = true,
  });

  @override
  Widget build(BuildContext context) {
    final rating = RatingHelper.toFiveStar(voteAverage);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < rating.floor()
                ? Icons.star_rounded
                : index < rating
                    ? Icons.star_half_rounded
                    : Icons.star_border_rounded,
            color: AppColors.accentGold,
            size: starSize,
          );
        }),
        if (showNumber) ...[
          const SizedBox(width: 6),
          Text(
            RatingHelper.format(voteAverage),
            style: TextStyle(
              fontFamily: 'SpaceMono',
              fontSize: starSize,
              fontWeight: FontWeight.w700,
              color: AppColors.accentGold,
            ),
          ),
        ],
      ],
    );
  }
}
