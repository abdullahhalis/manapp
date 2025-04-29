import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manapp/repository/manga_repository.dart';
import 'package:manapp/service/api_service.dart';
import 'package:manapp/service/favorite_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final favoriteServiceProvider = Provider<FavoriteService>((ref) {
  return FavoriteService.instance;
});

final mangaRepositoryProvider = Provider<MangaRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final favoriteService = ref.watch(favoriteServiceProvider);
  return MangaRepository(apiService, favoriteService);
});
