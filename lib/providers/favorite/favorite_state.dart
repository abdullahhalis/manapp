import 'package:manapp/models/detail_manga_model.dart';

class FavoriteState {
  final bool isLoading;
  final String errorMessage;
  final List<Map<String, DetailMangaModel>> favorites;

  const FavoriteState({
    this.isLoading = false,
    this.errorMessage = '',
    this.favorites = const [],
  });

  FavoriteState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Map<String, DetailMangaModel>>? favorites,
  }) {
    return FavoriteState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      favorites: favorites ?? this.favorites,
    );
  }

  List<Map<String, DetailMangaModel>> get reversedFavorites {
    return favorites.reversed.toList();
  }
}
