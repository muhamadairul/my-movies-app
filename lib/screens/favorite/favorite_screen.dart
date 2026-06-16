import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/favorite_provider.dart';
import 'widgets/favorite_movie_card.dart';

/// Halaman daftar film favorit pengguna.
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<FavoriteProvider>(
          builder: (context, provider, child) {
            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Favorit Saya', style: AppTextStyles.headingM),
                        const SizedBox(height: 4),
                        Text(
                          '${provider.count} film tersimpan',
                          style: AppTextStyles.bodyM,
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                if (provider.favorites.isEmpty)
                  SliverFillRemaining(
                    child: _buildEmptyState(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final movie = provider.favorites[index];
                          return FavoriteMovieCard(
                            movie: movie,
                            onTap: () => context.push('/detail/${movie.id}'),
                            onRemove: () {
                              provider.removeFavorite(movie.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Dihapus dari favorit'),
                                  backgroundColor: AppColors.surfaceElevated,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  action: SnackBarAction(
                                    label: 'Batal',
                                    textColor: AppColors.accentGold,
                                    onPressed: () => provider.toggleFavorite(movie),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        childCount: provider.favorites.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 80,
            color: AppColors.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada favorit',
            style: AppTextStyles.headingM.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Ketuk ikon ❤️ pada film apa saja untuk menyimpannya di sini',
              style: AppTextStyles.bodyM,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}