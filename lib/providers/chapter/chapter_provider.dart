import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manapp/models/detail_manga_model.dart';
import 'package:manapp/providers/chapter/chapter_state.dart';
import 'package:manapp/providers/repository_provider.dart';
import 'package:manapp/repository/manga_repository.dart';

final chapterProvider =
    StateNotifierProvider.family<ChapterProvider, ChapterState, String>((
      ref,
      slug,
    ) {
      final mangaRepository = ref.watch(mangaRepositoryProvider);
      return ChapterProvider(mangaRepository)..fetchChapterManga(slug);
    });

class ChapterProvider extends StateNotifier<ChapterState> {
  final MangaRepository _mangaRepository;

  ChapterProvider(this._mangaRepository) : super(const ChapterState());

  Future<void> fetchChapterManga(String slug) async {
    state = state.copyWith(isLoading: true);
    try {
      final chapter = await _mangaRepository.fetchChapterManga(slug);
      state = state.copyWith(isLoading: false, chapter: chapter);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  String? getPreviousChapterSlug(DetailMangaModel detail, String currentSlug) {
    final chapters = detail.chapters;
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

  String? getNextChapterSlug(DetailMangaModel detail, String currentSlug) {
    final chapters = detail.chapters;
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
