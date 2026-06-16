import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/movie_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/shimmer_card.dart';
import 'widgets/featured_banner.dart';
import 'widgets/genre_chip_row.dart';
import 'widgets/movie_horizontal_list.dart';

/// Halaman beranda utama aplikasi MyMovies.
/// Menampilkan banner hero, genre filter, dan section film horizontal.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentBannerPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _startAutoScroll();
  }

  Future<void> _initializeData() async {
    final movieProvider = context.read<MovieProvider>();
    final favoriteProvider = context.read<FavoriteProvider>();
    await Future.wait([
      movieProvider.fetchHomeData(),
      favoriteProvider.loadFavorites(),
    ]);
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentBannerPage + 1) % 5;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToDetail(int movieId) {
    context.push('/detail/$movieId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.state == ScreenState.loading) {
            return _buildShimmerLoading();
          }

          if (provider.state == ScreenState.error) {
            return AppErrorWidget(
              message: provider.errorMessage,
              onRetry: () => provider.fetchHomeData(),
            );
          }

          return RefreshIndicator(
            color: AppColors.accentGold,
            backgroundColor: AppColors.surfaceCard,
            onRefresh: () => provider.fetchHomeData(),
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverToBoxAdapter(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Datang',
                                style: AppTextStyles.caption,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Jelajahi Film',
                                style: AppTextStyles.headingM,
                              ),
                            ],
                          ),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceCard,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.notifications_none_rounded,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Featured Banner
                SliverToBoxAdapter(
                  child: FeaturedBanner(
                    movies: provider.nowPlaying.take(5).toList(),
                    pageController: _pageController,
                    onPageChanged: (page) => setState(() => _currentBannerPage = page),
                    currentPage: _currentBannerPage,
                    onMovieTap: (movie) => _navigateToDetail(movie.id),
                  ).animate().fadeIn(duration: 600.ms),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // Genre Chips
                SliverToBoxAdapter(
                  child: GenreChipRow(
                    genres: provider.genres,
                    selectedGenre: provider.selectedGenre,
                    onGenreSelected: provider.selectGenre,
                  ).animate().slideX(begin: -0.1, duration: 500.ms),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // Now Playing Section
                SliverToBoxAdapter(
                  child: MovieHorizontalList(
                    title: 'Sedang Tayang',
                    movies: provider.nowPlaying,
                    onMovieTap: (movie) => _navigateToDetail(movie.id),
                  ).animate().fadeIn(delay: 200.ms),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // Popular Section
                SliverToBoxAdapter(
                  child: MovieHorizontalList(
                    title: 'Film Populer',
                    movies: provider.popular,
                    onMovieTap: (movie) => _navigateToDetail(movie.id),
                  ).animate().fadeIn(delay: 300.ms),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // Top Rated Grid Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Rating Tertinggi', style: AppTextStyles.headingM),
                  ).animate().fadeIn(delay: 400.ms),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Top Rated Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final movie = provider.topRated[index];
                        return _buildGridCard(provider, movie);
                      },
                      childCount: provider.topRated.length.clamp(0, 6),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // Upcoming Section
                SliverToBoxAdapter(
                  child: MovieHorizontalList(
                    title: 'Akan Datang',
                    movies: provider.upcoming,
                    onMovieTap: (movie) => _navigateToDetail(movie.id),
                  ).animate().fadeIn(delay: 500.ms),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridCard(MovieProvider provider, movie) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final isFav = favoriteProvider.isFavorited(movie.id);

    return GestureDetector(
      onTap: () => _navigateToDetail(movie.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit.cover,
                  ),
                  // Coming Soon Badge for upcoming
                  if (provider.upcoming.contains(movie))
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentGold,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Segera',
                          style: AppTextStyles.labelTag.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => favoriteProvider.toggleFavorite(movie),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey(isFav),
                          color: isFav ? AppColors.accentGold : Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyM.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 14),
              const SizedBox(width: 4),
              Text(
                '${(movie.voteAverage / 2).toStringAsFixed(1)}',
                style: AppTextStyles.ratingNum,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Shimmer banner
        const ShimmerCard(width: double.infinity, height: 280, borderRadius: 16),
        const SizedBox(height: 24),
        // Shimmer chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: List.generate(4, (_) => const Padding(
              padding: EdgeInsets.only(right: 10),
              child: ShimmerCard(width: 80, height: 36, borderRadius: 20),
            )),
          ),
        ),
        const SizedBox(height: 32),
        // Shimmer sections
        ...List.generate(3, (index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerText(width: 150, height: 24),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: List.generate(3, (_) => const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: ShimmerCard(width: 130, height: 195),
                )),
              ),
            ),
            const SizedBox(height: 32),
          ],
        )),
      ],
    );
  }
}