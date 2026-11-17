import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/game.dart';
import '../utils/constants.dart';

/// Mengelola library game (game yang dimiliki) di Hive.
/// Kunci tiap data = id game (dalam bentuk String).
class LibraryService {
  static Box get _box => Hive.box(kLibraryBox);

  /// Dipakai ValueListenableBuilder supaya UI otomatis ter-update
  /// setiap isi box berubah.
  static ValueListenable<Box> get listenable => _box.listenable();

  /// Apakah game dengan [id] sudah ada di library?
  static bool contains(int id) => _box.containsKey(id.toString());

  /// Jumlah game di library.
  static int get count => _box.length;

  /// Semua game di library.
  static List<Game> all() {
    return _box.values
        .map((e) => Game.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  static Future<void> add(Game game) async {
    await _box.put(game.id.toString(), game.toMap());
  }

  static Future<void> remove(int id) async {
    await _box.delete(id.toString());
  }
}
