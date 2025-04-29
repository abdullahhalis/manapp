import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:manapp/models/detail_manga_model.dart';

class FavoriteService {
  static const String _boxName = 'favorites';
  late final Box _box;

  FavoriteService._privateConstructor();

  static final FavoriteService _instance =
      FavoriteService._privateConstructor();

  static FavoriteService get instance => _instance;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Future<void> addFavorite(String slug, DetailMangaModel detailManga) async {
    await _box.put(slug, detailManga.toJson());
  }

  Future<void> removeFavorite(String slug) async {
    await _box.delete(slug);
  }

  bool isFavorite(String slug) {
    return _box.containsKey(slug);
  }

  List<Map<String, DetailMangaModel>> getAllFavorites() {
    final result = <Map<String, DetailMangaModel>>[];

    _box.toMap().forEach((key, value) {
      if (key is String && value is Map<dynamic, dynamic>) {
        try {
          final model = DetailMangaModel.fromJson(
            Map<String, dynamic>.from(value),
          );
          result.add({key: model});
        } catch (e) {
          log('Error parsing favorite item [$key]: $e');
        }
      }
    });

    return result;
  }

  DetailMangaModel? getFavorite(String slug) {
    final raw = _box.get(slug);
    if (raw is Map) {
      return DetailMangaModel.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  Future<void> clearFavorites() async {
    await _box.clear();
  }
}
