import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/api_constants.dart';
import '../../../data/models/cast_model.dart';

/// Horizontal list untuk menampilkan cast film.
class CastList extends StatelessWidget {
  final List<CastModel> cast;

  const CastList({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Pemeran', style: AppTextStyles.headingM),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: cast.take(10).length,
            itemBuilder: (context, index) {
              final actor = cast[index];
              return _buildCastItem(actor);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCastItem(CastModel actor) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: CachedNetworkImage(
              imageUrl: ApiConstants.profileUrl(actor.profilePath),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 80,
                height: 80,
                color: AppColors.surfaceCard,
                child: const Icon(Icons.person, color: AppColors.textMuted),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: AppColors.surfaceCard,
                child: const Icon(Icons.person, color: AppColors.textMuted),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            actor.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyM.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            actor.character ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}