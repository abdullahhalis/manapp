import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manapp/providers/repository_provider.dart';

final chapterProvider = FutureProvider.family.autoDispose((ref, String slug) async {
  final mangaRepository = ref.watch(mangaRepositoryProvider);
  try {
    final chapter = await mangaRepository.fetchChapterManga(slug);
    return chapter;
  } catch (e) {
    throw Exception('Failed to fetch chapter: $e');
  }
});