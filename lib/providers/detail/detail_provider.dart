import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manapp/providers/detail/detail_state.dart';
import 'package:manapp/providers/repository_provider.dart';
import 'package:manapp/repository/manga_repository.dart';

final detailNotifierProvider =
    StateNotifierProvider.family<DetailProvider, DetailState, String>((ref, slug) {
  final mangaRepository = ref.watch(mangaRepositoryProvider);
  return DetailProvider(mangaRepository)..fetchDetailManga(slug);
});

class DetailProvider extends StateNotifier<DetailState> {
  final MangaRepository _mangaRepository;

  DetailProvider(this._mangaRepository) : super(const DetailState());

  Future<void> fetchDetailManga(String slug) async {
    state = state.copyWith(isLoading: true);
    try {
      final detailManga = await _mangaRepository.fetchDetailManga(slug);
      state = state.copyWith(isLoading: false, detailManga: detailManga);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
