import 'package:manapp/models/manga_model.dart';

class HomeState {
  final bool isLoading;
  final List<MangaModel> popularToday;
  final List<MangaModel> latestUpdate;
  final List<MangaModel> newSeries;
  final List<MangaModel> weeklyPopular;
  final List<MangaModel> monthlyPopular;
  final List<MangaModel> alltimePopular;
  final List<MangaModel> searchResult;
  final String errorMessage;

  const HomeState({
    this.isLoading = false,
    this.popularToday = const [],
    this.latestUpdate = const [],
    this.newSeries = const [],
    this.weeklyPopular = const [],
    this.monthlyPopular = const [],
    this.alltimePopular = const [],
    this.searchResult = const [],
    this.errorMessage = '',
  });
  
  HomeState copyWith({
    bool? isLoading,
    List<MangaModel>? popularToday,
    List<MangaModel>? latestUpdate,
    List<MangaModel>? newSeries,
    List<MangaModel>? weeklyPopular,
    List<MangaModel>? monthlyPopular,
    List<MangaModel>? alltimePopular,
    List<MangaModel>? searchResult,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      popularToday: popularToday ?? this.popularToday,
      latestUpdate: latestUpdate ?? this.latestUpdate,
      newSeries: newSeries ?? this.newSeries,
      weeklyPopular: weeklyPopular ?? this.weeklyPopular,
      monthlyPopular: monthlyPopular ?? this.monthlyPopular,
      alltimePopular: alltimePopular ?? this.alltimePopular,
      searchResult: searchResult ?? this.searchResult,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
