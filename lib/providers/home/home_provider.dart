import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manapp/providers/home/home_state.dart';
import 'package:manapp/providers/repository_provider.dart';
import 'package:manapp/repository/manga_repository.dart';

final homeProvider = StateNotifierProvider<HomeProvider, HomeState>((ref) {
  final mangaRepository = ref.watch(mangaRepositoryProvider);
  return HomeProvider(mangaRepository);
});

class HomeProvider extends StateNotifier<HomeState> {
  final MangaRepository _mangaRepository;
  Timer? _debounce;
  String _lastQuery = '';
  HomeProvider(this._mangaRepository) : super(const HomeState());

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

  void updateSearchQuery(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if (query != _lastQuery) {
        _lastQuery = query;
        _searchManga(query);
      }
    });
  }

  Future<void> _searchManga(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchResult: []);
      return;
    }
    state = state.copyWith(isLoading: true);
    try {
      final results = await _mangaRepository.fetchSearchManga(query);
      state = state.copyWith(isLoading: false, searchResult: results.data);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      log('(SearchManga) error: $e');
    }
  }
}
