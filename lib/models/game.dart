/// Data ringkas game (untuk list di Home dan Library).
class Game {
  final int id;
  final String title;
  final String thumbnail;
  final String genre;
  final String platform;

  const Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
  });

  /// Dari JSON API.
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      genre: json['genre'] as String? ?? '-',
      platform: json['platform'] as String? ?? '-',
    );
  }

  /// Untuk disimpan ke Hive.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'genre': genre,
      'platform': platform,
    };
  }

  /// Dari data Hive.
  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'] as int,
      title: map['title'] as String,
      thumbnail: map['thumbnail'] as String,
      genre: map['genre'] as String,
      platform: map['platform'] as String,
    );
  }
}

/// Data lengkap game (untuk Detail Page).
class GameDetail {
  final int id;
  final String title;
  final String thumbnail;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final String releaseDate;
  final String description;
  final List<String> screenshots;

  const GameDetail({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    required this.description,
    required this.screenshots,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    // screenshots bisa berupa list URL (String) atau list objek {id, image}.
    final shots = (json['screenshots'] as List<dynamic>? ?? []).map((item) {
      if (item is String) return item;
      if (item is Map) return (item['image'] ?? '').toString();
      return '';
    }).where((url) => url.isNotEmpty).toList();

    return GameDetail(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      genre: json['genre'] as String? ?? '-',
      platform: json['platform'] as String? ?? '-',
      publisher: json['publisher'] as String? ?? '-',
      developer: json['developer'] as String? ?? '-',
      releaseDate: json['release_date'] as String? ?? '-',
      description: json['description'] as String? ?? '',
      screenshots: shots,
    );
  }

  /// Ubah ke Game ringkas, dipakai saat menambah ke library.
  Game toGame() {
    return Game(
      id: id,
      title: title,
      thumbnail: thumbnail,
      genre: genre,
      platform: platform,
    );
  }
}
