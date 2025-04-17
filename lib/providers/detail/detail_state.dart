import 'package:manapp/models/detail_manga_model.dart';

class DetailState {
  final bool isLoading;
  final String errorMessage;
  final DetailMangaModel detailManga;

  const DetailState({
    this.isLoading = false,
    this.errorMessage = '',
    this.detailManga = const DetailMangaModel(),
  });

  DetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    DetailMangaModel? detailManga,
  }) {
    return DetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      detailManga: detailManga ?? this.detailManga,
    );
  }
}