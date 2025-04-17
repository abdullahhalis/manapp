class MangaModel {
  final String? title;
  final String? type;
  final String? chapter;
  final String? rating;
  final String? image;
  final String? slug;

  const MangaModel({
    this.title,
    this.type,
    this.chapter,
    this.rating,
    this.image,
    this.slug,
  });

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    return MangaModel(
      title: json['title'],
      type: json['type'],
      chapter: json['chapter'],
      rating: json['rating'],
      image: json['image'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'chapter': chapter,
      'rating': rating,
      'image': image,
      'slug': slug,
    };
  }
}
