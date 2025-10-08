import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manapp/constants/app_routes.dart';
import 'package:manapp/screens/chapter_screen.dart';
import 'package:manapp/screens/detail_screen.dart';
import 'package:manapp/screens/favorite_screen.dart';
import 'package:manapp/screens/home_screen.dart';
import 'package:manapp/screens/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        name: AppRoutes.splashName,
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: AppRoutes.homeName,
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: AppRoutes.detailName,
        path: AppRoutes.detail,
        builder: (context, state) {
          final slug = state.pathParameters['slug'];
          if (slug == null || slug.isEmpty) {
            return const HomeScreen();
          }
          return DetailScreen(slug: slug);
        },
      ),
      GoRoute(
        name: AppRoutes.chapterName,
        path: AppRoutes.chapter,
        builder: (context, state) {
          final slug = state.pathParameters['slug'];
          if (slug == null || slug.isEmpty) {
            return const HomeScreen();
          }
          return ChapterScreen(key: Key(slug), slug: slug);
        },
      ),
      GoRoute(
        name: AppRoutes.favoritesName,
        path: AppRoutes.favorites,
        builder: (context, state) => const FavoriteScreen(),
      ),
    ],
  );
});
