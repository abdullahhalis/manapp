import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manapp/repository/manga_repository.dart';
import 'package:manapp/service/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final mangaRepositoryProvider = Provider<MangaRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return MangaRepository(apiService);
});