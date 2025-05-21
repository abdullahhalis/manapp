import 'package:manapp/models/manga_model.dart';

class HomeState {
  final int currentPage;
  final int searchPage;
  final bool isLoading;
  final bool isSearching;
  final bool isSearchingMore;
  final bool hasMoreSearchResults;
  final List<MangaModel> popularToday;
  final List<MangaModel> latestUpdate;
  final List<MangaModel> newSeries;
  final List<MangaModel> weeklyPopular;
  final List<MangaModel> monthlyPopular;
  final List<MangaModel> alltimePopular;
  final List<MangaModel> searchResult;
  final String errorMessage;
  final String searchErrorMessage;

  const HomeState({
    this.currentPage = 1,
    this.searchPage = 1,
    this.isLoading = false,
    this.isSearching = false,
    this.isSearchingMore = false,
    this.hasMoreSearchResults = true,
    this.popularToday = const [],
    this.latestUpdate = const [],
    this.newSeries = const [],
    this.weeklyPopular = const [],
    this.monthlyPopular = const [],
    this.alltimePopular = const [],
    this.searchResult = const [],
    this.errorMessage = '',
    this.searchErrorMessage = '',
  });

  HomeState copyWith({
    int? currentPage,
    int? searchPage,
    bool? isLoading,
    bool? isSearching,
    bool? isSearchingMore,
    bool? hasMoreSearchResults,
    List<MangaModel>? popularToday,
    List<MangaModel>? latestUpdate,
    List<MangaModel>? newSeries,
    List<MangaModel>? weeklyPopular,
    List<MangaModel>? monthlyPopular,
    List<MangaModel>? alltimePopular,
    List<MangaModel>? searchResult,
    String? errorMessage,
    String? searchErrorMessage,
  }) {
    return HomeState(
      currentPage: currentPage ?? this.currentPage,
      searchPage: searchPage ?? this.searchPage,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      isSearchingMore: isSearchingMore ?? this.isSearchingMore,
      hasMoreSearchResults: hasMoreSearchResults ?? this.hasMoreSearchResults,
      popularToday: popularToday ?? this.popularToday,
      latestUpdate: latestUpdate ?? this.latestUpdate,
      newSeries: newSeries ?? this.newSeries,
      weeklyPopular: weeklyPopular ?? this.weeklyPopular,
      monthlyPopular: monthlyPopular ?? this.monthlyPopular,
      alltimePopular: alltimePopular ?? this.alltimePopular,
      searchResult: searchResult ?? this.searchResult,
      errorMessage: errorMessage ?? this.errorMessage,
      searchErrorMessage: searchErrorMessage ?? this.searchErrorMessage,
    );
  }
}
