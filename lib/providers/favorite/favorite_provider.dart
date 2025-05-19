import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manapp/providers/favorite/favorite_state.dart';
import 'package:manapp/providers/repository_provider.dart';
import 'package:manapp/repository/manga_repository.dart';

final favoriteProvider = StateNotifierProvider<FavoriteProvider, FavoriteState>(
  (ref) {
    final mangaRepository = ref.watch(mangaRepositoryProvider);
    return FavoriteProvider(mangaRepository);
  },
);

class FavoriteProvider extends StateNotifier<FavoriteState> {
  final MangaRepository _mangaRepository;
  FavoriteProvider(this._mangaRepository) : super(const FavoriteState());

  fetchFavorites() {
    state = state.copyWith(isLoading: true);
    try {
      final favorites = _mangaRepository.getAllFavorites();
      state = state.copyWith(isLoading: false, favorites: favorites);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> clearFavorites() async {
    await _mangaRepository.clearFavorites();
    state = state.copyWith(favorites: []);
  }
}
