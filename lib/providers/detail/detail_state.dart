import 'package:manapp/models/detail_manga_model.dart';

class DetailState {
  final bool isLoading;
  final String errorMessage;
  final DetailMangaModel detailManga;
  final bool isFavorite;

  const DetailState({
    this.isLoading = false,
    this.errorMessage = '',
    this.detailManga = const DetailMangaModel(),
    this.isFavorite = false,
  });

  DetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    DetailMangaModel? detailManga,
    bool? isFavorite,
  }) {
    return DetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      detailManga: detailManga ?? this.detailManga,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}