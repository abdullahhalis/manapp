import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manapp/providers/home/home_state.dart';
import 'package:manapp/providers/repository_provider.dart';
import 'package:manapp/repository/manga_repository.dart';

final homeProvider = StateNotifierProvider<HomeProvider, HomeState>((ref) {
  final mangaRepository = ref.watch(mangaRepositoryProvider);
  return HomeProvider(mangaRepository);
});

final searchResultProvider = FutureProvider.family.autoDispose((ref, String query) async {
  final mangaRepository = ref.watch(mangaRepositoryProvider);
  try {
    final results = await mangaRepository.fetchSearchManga(query);
    return results;
  } catch (e) {
    throw Exception('Failed to search manga: $e');
  }
});

class HomeProvider extends StateNotifier<HomeState>{
  final MangaRepository _mangaRepository;
  HomeProvider(this._mangaRepository) : super(const HomeState()) {
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    state = state.copyWith(isLoading: true);
    try {
      final homeData = await _mangaRepository.fetchHomeData();
      state = state.copyWith(
        isLoading: false,
        popularToday: homeData.popularToday,
        latestUpdate: homeData.latestUpdate,
        newSeries: homeData.newSeries,
        weeklyPopular: homeData.weeklyPopular,
        monthlyPopular: homeData.monthlyPopular,
        alltimePopular: homeData.alltimePopular,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}