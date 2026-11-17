import 'package:flutter/material.dart';

import '../models/game.dart';
import '../services/api_service.dart';
import '../widgets/game_tile.dart';
import 'detail_page.dart';

/// Tab Home: daftar semua game dari API.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Game>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchGames();
  }

  void _muatUlang() {
    setState(() {
      _future = ApiService.fetchGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Game>>(
      future: _future,
      builder: (context, snapshot) {
        // 1) Loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2) Gagal memuat
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(
                    'Gagal memuat daftar game. Periksa koneksi internet.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _muatUlang,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        // 3) Tampilkan list
        final games = snapshot.data ?? [];
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return GameTile(
              game: game,
              trailing: const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.chevron_right),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(gameId: game.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
