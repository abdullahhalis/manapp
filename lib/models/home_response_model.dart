import 'package:manapp/models/manga_model.dart';

class HomeResponseModel {
  final List<MangaModel> popularToday;
  final List<MangaModel> latestUpdate;
  final List<MangaModel> newSeries;
  final List<MangaModel> weeklyPopular;
  final List<MangaModel> monthlyPopular;
  final List<MangaModel> alltimePopular;

  const HomeResponseModel({
    required this.popularToday,
    required this.latestUpdate,
    required this.newSeries,
    required this.weeklyPopular,
    required this.monthlyPopular,
    required this.alltimePopular,
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    List<MangaModel> parseList(String key) {
      final list = json[key];
      if (list is List) {
        return list.map((v) => MangaModel.fromJson(v)).toList();
      }
      return [];
    }

    return HomeResponseModel(
      popularToday: parseList('popularToday'),
      latestUpdate: parseList('latestUpdate'),
      newSeries: parseList('newSeries'),
      weeklyPopular: parseList('weeklyPopular'),
      monthlyPopular: parseList('monthlyPopular'),
      alltimePopular: parseList('alltimePopular'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'popularToday': popularToday.map((v) => v.toJson()).toList(),
      'latestUpdate': latestUpdate.map((v) => v.toJson()).toList(),
      'newSeries': newSeries.map((v) => v.toJson()).toList(),
      'weeklyPopular': weeklyPopular.map((v) => v.toJson()).toList(),
      'monthlyPopular': monthlyPopular.map((v) => v.toJson()).toList(),
      'alltimePopular': alltimePopular.map((v) => v.toJson()).toList(),
    };
  }
}
