import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/search_provider.dart';
import '../../providers/movie_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/shimmer_card.dart';
import 'widgets/search_movie_card.dart';

/// Halaman pencarian film dengan debounce.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  onChanged: (value) {
                    context.read<SearchProvider>().onSearchChanged(value);
                  },
                  style: AppTextStyles.bodyL,
                  decoration: InputDecoration(
                    hintText: 'Cari film...',
                    hintStyle: AppTextStyles.bodyL.copyWith(color: AppColors.textMuted),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, color: AppColors.textMuted),
                            onPressed: () {
                              _searchController.clear();
                              context.read<SearchProvider>().clearSearch();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, provider, child) {
                  switch (provider.state) {
                    case ScreenState.initial:
                      return _buildEmptyState();
                    case ScreenState.loading:
                      return _buildLoadingState();
                    case ScreenState.empty:
                      return _buildNoResults(provider.query);
                    case ScreenState.error:
                      return AppErrorWidget(
                        message: provider.errorMessage,
                        onRetry: () => provider.onSearchChanged(provider.query),
                      );
                    case ScreenState.loaded:
                      return _buildResults(provider);
                  }
                },
              ),
            ),
          ],
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
            Icons.movie_filter_outlined,
            size: 80,
            color: AppColors.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Mau cari film apa?',
            style: AppTextStyles.headingM.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          Text(
            'Ketik judul film yang ingin kamu cari',
            style: AppTextStyles.bodyM,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              ShimmerCard(width: 80, height: 120, borderRadius: 8),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerText(width: double.infinity, height: 18),
                    SizedBox(height: 8),
                    ShimmerText(width: 100, height: 14),
                    SizedBox(height: 8),
                    ShimmerText(width: double.infinity, height: 14),
                    SizedBox(height: 4),
                    ShimmerText(width: 150, height: 14),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoResults(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada hasil untuk "$query"',
            style: AppTextStyles.headingM.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResults(SearchProvider provider) {
    final favoriteProvider = context.watch<FavoriteProvider>();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: provider.results.length,
      itemBuilder: (context, index) {
        final movie = provider.results[index];
        return SearchMovieCard(
          movie: movie,
          isFavorited: favoriteProvider.isFavorited(movie.id),
          onTap: () => context.push('/detail/${movie.id}'),
          onFavoriteTap: () => favoriteProvider.toggleFavorite(movie),
        );
      },
    );
  }
}