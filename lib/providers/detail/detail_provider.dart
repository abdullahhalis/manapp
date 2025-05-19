import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manapp/models/detail_manga_model.dart';
import 'package:manapp/providers/detail/detail_state.dart';
import 'package:manapp/providers/repository_provider.dart';
import 'package:manapp/repository/manga_repository.dart';

final detailNotifierProvider =
    StateNotifierProvider.family<DetailProvider, DetailState, String>((
      ref,
      slug,
    ) {
      final mangaRepository = ref.watch(mangaRepositoryProvider);
      return DetailProvider(mangaRepository, ref)..fetchDetailManga(slug);
    });

final detailMangaProvider = StateProvider<DetailMangaModel?>((ref) => null);

class DetailProvider extends StateNotifier<DetailState> {
  final MangaRepository _mangaRepository;
  final Ref ref;

  DetailProvider(this._mangaRepository, this.ref) : super(const DetailState());

  Future<void> fetchDetailManga(String slug) async {
    state = state.copyWith(isLoading: true);
    try {
      final detailManga = await _mangaRepository.fetchDetailManga(slug);
      final isFavorite = _mangaRepository.isFavorite(slug);
      state = state.copyWith(
        isLoading: false,
        detailManga: detailManga,
        chapters: detailManga.chapters,
        isFavorite: isFavorite,
      );
      ref.read(detailMangaProvider.notifier).state = detailManga;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addFavorite(String slug) async {
    await _mangaRepository.addFavorite(slug, state.detailManga);
    state = state.copyWith(isFavorite: _mangaRepository.isFavorite(slug));
  }

  Future<void> removeFavorite(String slug) async {
    await _mangaRepository.removeFavorite(slug);
    state = state.copyWith(isFavorite: _mangaRepository.isFavorite(slug));
  }

  Future<void> addChapterToHistory(String slug) async {
    await _mangaRepository.addChapterToHistory(slug);
  }

  bool isChapterInHistory(String slug) {
    return _mangaRepository.isChapterInHistory(slug);
  }

  reverseChapter() {
    state = state.copyWith(chapters: state.chapters.reversed.toList());
  }
}
