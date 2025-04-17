import 'package:manapp/models/manga_model.dart';

class SearchResponseModel {
  final List<MangaModel> data;

  const SearchResponseModel({
    required this.data,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      data: (json['data'] as List)
          .map((item) => MangaModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}