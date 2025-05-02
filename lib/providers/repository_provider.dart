import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manapp/repository/manga_repository.dart';
import 'package:manapp/service/api_service.dart';
import 'package:manapp/service/favorite_service.dart';
import 'package:manapp/service/history_service.dart';

final apiServiceProvider = Provider<ApiService>((_) {
  return ApiService();
});

final favoriteServiceProvider = Provider<FavoriteService>((_) {
  return FavoriteService.instance;
});

final historyServiceProvider = Provider<HistoryService>((_) {
  return HistoryService.instance;
});

final mangaRepositoryProvider = Provider<MangaRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final favoriteService = ref.watch(favoriteServiceProvider);
  final historyService = ref.watch(historyServiceProvider);
  return MangaRepository(apiService, favoriteService, historyService);
});
