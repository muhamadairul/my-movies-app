import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'providers/auth_provider.dart';
import 'providers/movie_provider.dart';
import 'providers/search_provider.dart';
import 'providers/favorite_provider.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/detail/detail_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/favorite/favorite_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'widgets/bottom_nav_bar.dart';

/// Main shell dengan bottom navigation.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    SearchScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

/// Root widget aplikasi MyMovies.
class MyMoviesApp extends StatefulWidget {
  const MyMoviesApp({super.key});

  @override
  State<MyMoviesApp> createState() => _MyMoviesAppState();
}

class _MyMoviesAppState extends State<MyMoviesApp> {
  late final AuthProvider _authProvider;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider()..checkLoginStatus();
    _router = GoRouter(
      initialLocation: '/',
      refreshListenable: _authProvider,
      redirect: (context, state) {
        final isLoggedIn = _authProvider.isLoggedIn;
        final isLoginRoute = state.matchedLocation == '/login';

        if (!isLoggedIn && !isLoginRoute) {
          return '/login';
        }
        if (isLoggedIn && isLoginRoute) {
          return '/';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const MainShell(),
        ),
        GoRoute(
          path: '/detail/:id',
          builder: (context, state) {
            final movieId = int.parse(state.pathParameters['id']!);
            return DetailScreen(movieId: movieId);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()..loadFavorites()),
      ],
      child: MaterialApp.router(
        title: 'MyMovies',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accentGold,
            surface: AppColors.surfaceCard,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleTextStyle: AppTextStyles.headingM,
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: AppColors.surfaceCard,
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}