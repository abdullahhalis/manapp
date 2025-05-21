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
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      final homeData = await _mangaRepository.fetchHomeData(
        page: state.currentPage,
      );
      state = state.copyWith(
        currentPage: state.currentPage + 1,
        isLoading: false,
        popularToday: homeData.popularToday,
        latestUpdate: [...state.latestUpdate, ...homeData.latestUpdate],
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
        state = state.copyWith(searchPage: 1, searchResult: []);
        _searchManga(query);
      }
    });
  }

  Future<void> _searchManga(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchResult: []);
      return;
    }
    if (state.isSearching) return;
    state = state.copyWith(
      isSearching: true,
      hasMoreSearchResults: true,
      searchResult: [],
    );
    try {
      final results = await _mangaRepository.fetchSearchManga(
        query,
        page: state.searchPage,
      );
      state = state.copyWith(
        searchPage: state.searchPage + 1,
        isSearching: false,
        searchResult: results.data,
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        searchErrorMessage: e.toString(),
      );
      log('(SearchManga) error: $e');
    }
  }

  Future<void> fetchMoreSearchResults() async {
    if (state.isSearchingMore || !state.hasMoreSearchResults) return;
    state = state.copyWith(isSearchingMore: true);
    try {
      final results = await _mangaRepository.fetchSearchManga(
        _lastQuery,
        page: state.searchPage,
      );
      final hasMore = results.data.isNotEmpty;
      state = state.copyWith(
        searchPage: state.searchPage + 1,
        isSearchingMore: false,
        hasMoreSearchResults: hasMore,
        searchResult: [...state.searchResult, ...results.data],
      );
    } catch (e) {
      state = state.copyWith(
        isSearchingMore: false,
        searchErrorMessage: e.toString(),
      );
    }
  }
}
