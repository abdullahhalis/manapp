import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manapp/constants/app_routes.dart';
import 'package:manapp/providers/favorite/favorite_provider.dart';
import 'package:manapp/providers/home/home_provider.dart';
import 'package:manapp/widgets/my_error_widget.dart';

final initProvider = FutureProvider.autoDispose((ref) async {
  ref.keepAlive();
  await Future.microtask(() async {
    await ref.read(favoriteProvider.notifier).fetchFavorites();
    await ref.read(homeProvider.notifier).fetchHomeData();
  });
});

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initWatch = ref.watch(initProvider);
    return Scaffold(
      body: initWatch.when(
        data: (_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed(AppRoutes.homeName);
          });
          return const SizedBox.shrink();
        },
        error: (error, _) {
          return MyErrorWidget(
            errorText: error.toString(),
            retryFunction: () => ref.refresh(initProvider),
          );
        },
        loading:
            () => Center(
              child: AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 500),
                child: Image.asset(
                  'assets/icon/logo.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
      ),
    );
  }
}
