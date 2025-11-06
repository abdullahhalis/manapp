import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manapp/models/detail_manga_model.dart';
import 'package:manapp/providers/chapter/chapter_state.dart';
import 'package:manapp/providers/detail/detail_provider.dart';
import 'package:manapp/providers/repository_provider.dart';
import 'package:manapp/repository/manga_repository.dart';

final chapterProvider =
    StateNotifierProvider.family<ChapterProvider, ChapterState, String>((
      ref,
      slug,
    ) {
      final mangaRepository = ref.watch(mangaRepositoryProvider);
      final detailManga = ref.watch(detailMangaProvider);
      return ChapterProvider(mangaRepository, detailManga)
        ..fetchChapterManga(slug);
    });

class ChapterProvider extends StateNotifier<ChapterState> {
  final MangaRepository _mangaRepository;
  final DetailMangaModel? _detailMangaModel;

  ChapterProvider(this._mangaRepository, this._detailMangaModel)
    : super(const ChapterState());

  Future<void> fetchChapterManga(String chapterSlug) async {
    state = state.copyWith(isLoading: true);
    try {
      final mangaSlug = _detailMangaModel?.slug;
      if (mangaSlug == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to Load Data',
        );
        return;
      }
      final chapter = await _mangaRepository.fetchChapterManga(
        mangaSlug,
        chapterSlug,
      );
      state = state.copyWith(isLoading: false, chapter: chapter);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  String? getPreviousChapterSlug(String currentSlug) {
    final chapters = _detailMangaModel?.chapters;
    if (chapters == null || chapters.isEmpty) return null;
    final orderedChapters = chapters.reversed.toList();
    final currentIndex = orderedChapters.indexWhere(
      (chapter) => chapter.slug == currentSlug,
    );
    if (currentIndex > 0) {
      return orderedChapters[currentIndex - 1].slug;
    }
    return null;
  }

  String? getNextChapterSlug(String currentSlug) {
    final chapters = _detailMangaModel?.chapters;
    if (chapters == null || chapters.isEmpty) return null;
    final orderedChapters = chapters.reversed.toList();
    final currentIndex = orderedChapters.indexWhere(
      (chapter) => chapter.slug == currentSlug,
    );
    if (currentIndex >= 0 && currentIndex < orderedChapters.length - 1) {
      return orderedChapters[currentIndex + 1].slug;
    }
    return null;
  }

  Future<void> addChapterToHistory(String slug) async {
    await _mangaRepository.addChapterToHistory(slug);
  }

  void toggleMenu() {
    state = state.copyWith(showMenu: !state.showMenu);
  }

  void hideMenu() {
    state = state.copyWith(showMenu: false);
  }

  void showMenu() {
    state = state.copyWith(showMenu: true);
  }
}
