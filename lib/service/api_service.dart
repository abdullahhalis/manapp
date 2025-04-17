import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:manapp/constants/api_constants.dart';
import 'package:manapp/models/chapter_model.dart';
import 'package:manapp/models/detail_manga_model.dart';
import 'package:manapp/models/home_response_model.dart';
import 'package:manapp/models/search_response_model.dart';

class ApiService {
  Future<HomeResponseModel> fetchHomeData() async {
    final url = Uri.parse(ApiConstants.homePath);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      return HomeResponseModel.fromJson(jsonBody['data']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<DetailMangaModel> fetchDetailManga(String slug) async {
    final url = Uri.parse('${ApiConstants.detailPath}/$slug');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      return DetailMangaModel.fromJson(jsonBody['data']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<ChapterModel> fetchChapterManga(String slug) async {
    final url = Uri.parse('${ApiConstants.chapterPath}/$slug');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      return ChapterModel.fromJson(jsonBody['data']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<SearchResponseModel> fetchSearchManga(String query) async {
    final url = Uri.parse('${ApiConstants.searchPath}?s=$query');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      return SearchResponseModel.fromJson(jsonBody['data']);
    } else {
      throw Exception('Failed to load data');
    }
  }
}