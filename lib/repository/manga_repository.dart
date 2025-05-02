import 'package:manapp/models/chapter_model.dart';
import 'package:manapp/models/detail_manga_model.dart';
import 'package:manapp/models/home_response_model.dart';
import 'package:manapp/models/search_response_model.dart';
import 'package:manapp/service/api_service.dart';
import 'package:manapp/service/favorite_service.dart';
import 'package:manapp/service/history_service.dart';

class MangaRepository {
  final ApiService _apiService;
  final FavoriteService _favoriteService;
  final HistoryService  _historyService;
  const MangaRepository(this._apiService, this._favoriteService, this._historyService);

  Future<HomeResponseModel> fetchHomeData() async {
    return await _apiService.fetchHomeData();
  }

  Future<DetailMangaModel> fetchDetailManga(String slug) async {
    return await _apiService.fetchDetailManga(slug);
  }

  Future<ChapterModel> fetchChapterManga(String slug) async {
    return await _apiService.fetchChapterManga(slug);
  }

  Future<SearchResponseModel> fetchSearchManga(String query) async {
    return await _apiService.fetchSearchManga(query);
  }

  Future<void> addFavorite(String slug, DetailMangaModel detailManga) async {
    await _favoriteService.addFavorite(slug, detailManga);
  }

  Future<void> removeFavorite(String slug) async {
    await _favoriteService.removeFavorite(slug);
  }

  bool isFavorite(String slug) {
    return _favoriteService.isFavorite(slug);
  }

  List<Map<String, DetailMangaModel>> getAllFavorites() {
    return _favoriteService.getAllFavorites();
  }

  DetailMangaModel? getFavorite(String slug) {
    return _favoriteService.getFavorite(slug);
  }

  Future<void> clearFavorites() async {
    await _favoriteService.clearFavorites();
  }

  Future<void> addChapterToHistory(slug) async {
    await _historyService.addChapterToHistory(slug);
  }

  bool isChapterInHistory(slug) {
    return _historyService.isChapterInHistory(slug);
  }

  List<String> getChaptersHistory() {
    return _historyService.getChaptersHistory();
  }
}
