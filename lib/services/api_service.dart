import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/game.dart';
import '../utils/constants.dart';

/// Semua proses fetch dan parse API ada di sini.
class ApiService {
  /// Daftar semua game: GET /games
  static Future<List<Game>> fetchGames() async {
    final response = await http
        .get(Uri.parse('$kBaseUrl/games'))
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat daftar game (kode ${response.statusCode})');
    }

    // utf8.decode supaya karakter khusus (mis. é) tidak rusak.
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return data
        .map((item) => Game.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Detail satu game: GET /game?id={id}
  static Future<GameDetail> fetchGameDetail(int id) async {
    final uri = Uri.parse('$kBaseUrl/game').replace(
      queryParameters: {'id': id.toString()},
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat detail game (kode ${response.statusCode})');
    }

    final data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return GameDetail.fromJson(data);
  }
}
