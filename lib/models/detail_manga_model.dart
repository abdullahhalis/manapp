class DetailMangaModel {
  final String? title;
  final String? altTitle;
  final String? image;
  final String? rating;
  final String? synopsis;
  final String? status;
  final String? type;
  final String? released;
  final String? author;
  final String? artist;
  final String? updatedAt;
  final List<String>? genre;
  final List<Chapters>? chapters;

  const DetailMangaModel({
    this.title,
    this.altTitle,
    this.image,
    this.rating,
    this.synopsis,
    this.status,
    this.type,
    this.released,
    this.author,
    this.artist,
    this.updatedAt,
    this.genre,
    this.chapters,
  });

  factory DetailMangaModel.fromJson(Map<String, dynamic> json) {
    return DetailMangaModel(
      title: json['title'],
      altTitle: json['alt_title'],
      image: json['image'],
      rating: json['rating'],
      synopsis: json['synopsis'],
      status: json['status'],
      type: json['type'],
      released: json['released'],
      author: json['author'],
      artist: json['artist'],
      updatedAt: json['updated_at'],
      genre: List<String>.from(json['genre'] ?? []),
      chapters:
          (json['chapters'] as List<dynamic>?)
              ?.map((e) => Chapters.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'alt_title': altTitle,
      'image': image,
      'rating': rating,
      'synopsis': synopsis,
      'status': status,
      'type': type,
      'released': released,
      'author': author,
      'artist': artist,
      'updated_at': updatedAt,
      'genre': genre,
      'chapters': chapters?.map((e) => e.toJson()).toList(),
    };
  }
}

class Chapters {
  final String? chapter;
  final String? slug;
  final String? date;

  const Chapters({this.chapter, this.slug, this.date});

  factory Chapters.fromJson(Map<String, dynamic> json) {
    return Chapters(
      chapter: json['chapter'],
      slug: json['slug'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'chapter': chapter, 'slug': slug, 'date': date};
  }
}
