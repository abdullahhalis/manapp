import 'package:manapp/models/chapter_model.dart';
import 'package:manapp/models/detail_manga_model.dart';
import 'package:manapp/models/home_response_model.dart';
import 'package:manapp/models/search_response_model.dart';
import 'package:manapp/service/api_service.dart';

class MangaRepository {
  final ApiService _apiService;
  const MangaRepository(this._apiService);

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
}