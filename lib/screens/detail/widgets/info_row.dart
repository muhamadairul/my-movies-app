import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Grid 2x2 untuk informasi film (tanggal, durasi, bahasa, budget).
class InfoGrid extends StatelessWidget {
  final String releaseDate;
  final String runtime;
  final String language;
  final String budget;

  const InfoGrid({
    super.key,
    required this.releaseDate,
    required this.runtime,
    required this.language,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _InfoItem(icon: Icons.calendar_today_outlined, label: 'Tanggal Rilis', value: releaseDate),
      _InfoItem(icon: Icons.access_time_rounded, label: 'Durasi', value: runtime),
      _InfoItem(icon: Icons.language_rounded, label: 'Bahasa', value: language),
      _InfoItem(icon: Icons.attach_money_rounded, label: 'Anggaran', value: budget),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildInfoCard(items[index]),
    );
  }

  Widget _buildInfoCard(_InfoItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(item.icon, color: AppColors.accentGold, size: 16),
              const SizedBox(width: 6),
              Text(item.label, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.value,
            style: AppTextStyles.bodyM.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  _InfoItem({required this.icon, required this.label, required this.value});
}