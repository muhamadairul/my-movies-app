import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:readmore/readmore.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/rating_helper.dart';
import '../../data/models/movie_model.dart';
import '../../providers/movie_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/error_widget.dart';
import 'widgets/movie_hero_header.dart';
import 'widgets/cast_list.dart';
import 'widgets/info_row.dart';

/// Halaman detail film dengan informasi lengkap.
class DetailScreen extends StatefulWidget {
  final int movieId;
  
  const DetailScreen({super.key, required this.movieId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchMovieDetail(widget.movieId);
    });
  }

  Future<void> _openTrailer(BuildContext context, String? key) async {
    if (key == null || key.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Trailer tidak tersedia untuk film ini'),
            backgroundColor: AppColors.surfaceElevated,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
      return;
    }
    final url = Uri.parse('https://www.youtube.com/watch?v=$key');
    try {
      final success = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!success && context.mounted) {
        throw Exception();
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal membuka trailer'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.state == ScreenState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentGold),
            );
          }

          if (provider.state == ScreenState.error) {
            return AppErrorWidget(
              message: provider.errorMessage,
              onRetry: () => provider.fetchMovieDetail(widget.movieId),
            );
          }

          final detail = provider.movieDetail;
          if (detail == null) return const SizedBox.shrink();

          final favoriteProvider = context.watch<FavoriteProvider>();
          final isFav = favoriteProvider.isFavorited(detail.id);

          return CustomScrollView(
            slivers: [
              // Hero Header
              SliverToBoxAdapter(
                child: MovieHeroHeader(
                  movie: detail,
                  isFavorited: isFav,
                  onFavoriteToggle: () {
                    favoriteProvider.toggleFavorite(
                      MovieModel(
                        id: detail.id,
                        title: detail.title,
                        posterPath: detail.posterPath,
                        voteAverage: detail.voteAverage,
                        voteCount: detail.voteCount,
                        releaseDate: detail.releaseDate,
                      ),
                    );
                  },
                  onBack: () => context.pop(),
                ),
              ),

              // Action Buttons
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      // Favorite Button
                      Expanded(
                        child: _buildActionButton(
                          icon: isFav ? Icons.favorite : Icons.favorite_border,
                          label: isFav ? 'Favorit' : 'Tambah Favorit',
                          isActive: isFav,
                          onTap: () {
                            favoriteProvider.toggleFavorite(
                              MovieModel(
                                id: detail.id,
                                title: detail.title,
                                posterPath: detail.posterPath,
                                voteAverage: detail.voteAverage,
                                voteCount: detail.voteCount,
                                releaseDate: detail.releaseDate,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Trailer Button
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.ondemand_video,
                          label: 'Trailer',
                          isActive: false,
                          isPrimary: true,
                          onTap: () => _openTrailer(context, provider.trailerKey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Synopsis
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sinopsis', style: AppTextStyles.headingM),
                      const SizedBox(height: 12),
                      ReadMoreText(
                        detail.overview ?? 'Tidak ada sinopsis tersedia.',
                        style: AppTextStyles.bodyL,
                        trimLines: 4,
                        colorClickableText: AppColors.accentGold,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: ' Baca selengkapnya',
                        trimExpandedText: ' Tutup',
                        moreStyle: AppTextStyles.bodyM.copyWith(
                          color: AppColors.accentGold,
                          fontWeight: FontWeight.w600,
                        ),
                        lessStyle: AppTextStyles.bodyM.copyWith(
                          color: AppColors.accentGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Info Grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InfoGrid(
                    releaseDate: DateFormatter.formatDate(detail.releaseDate),
                    runtime: DateFormatter.formatRuntime(detail.runtime),
                    language: detail.originalLanguage?.toUpperCase() ?? 'N/A',
                    budget: RatingHelper.formatCurrency(detail.budget),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // Cast List
              SliverToBoxAdapter(
                child: CastList(cast: provider.cast),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // Additional Info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (detail.tagline != null && detail.tagline!.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.accentGoldSoft),
                          ),
                          child: Text(
                            '"${detail.tagline}"',
                            style: AppTextStyles.bodyL.copyWith(
                              color: AppColors.accentGold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      if (detail.productionCompanies.isNotEmpty) ...[
                        Text('Produksi', style: AppTextStyles.headingM),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: detail.productionCompanies.map((company) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                company,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isActive,
    bool isPrimary = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.accentGold
              : isActive
                  ? AppColors.accentGoldSoft
                  : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary || isActive
              ? null
              : Border.all(color: AppColors.surfaceElevated),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary
                  ? Colors.black
                  : (isActive ? AppColors.accentGold : AppColors.textSecondary),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodyM.copyWith(
                color: isPrimary ? Colors.black : (isActive ? AppColors.accentGold : AppColors.textSecondary),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}