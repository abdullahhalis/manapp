import 'package:manapp/models/detail_manga_model.dart';

class DetailState {
  final bool isLoading;
  final String errorMessage;
  final DetailMangaModel detailManga;
  final List<Chapters> chapters;
  final bool isFavorite;

  const DetailState({
    this.isLoading = false,
    this.errorMessage = '',
    this.detailManga = const DetailMangaModel(),
    this.chapters = const [],
    this.isFavorite = false,
  });

  DetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    DetailMangaModel? detailManga,
    List<Chapters>? chapters,
    bool? isFavorite,
  }) {
    return DetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      detailManga: detailManga ?? this.detailManga,
      chapters: chapters ?? this.chapters,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}