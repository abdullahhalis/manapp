class ChapterModel {
  final String? title;
  final List<String>? images;

  const ChapterModel({this.title, this.images});

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      title: json['title'],
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'images': images,
    };
  }
}