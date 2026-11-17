import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/library_service.dart';
import '../widgets/game_tile.dart';
import 'detail_page.dart';

/// Tab Library: game yang dimiliki user (data dari Hive).
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Setiap isi box Hive berubah (tambah / hapus), builder dijalankan ulang.
    return ValueListenableBuilder<Box>(
      valueListenable: LibraryService.listenable,
      builder: (context, box, _) {
        final games = LibraryService.all();

        if (games.isEmpty) {
          return const Center(child: Text('Library masih kosong'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return GameTile(
              game: game,
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Hapus dari library',
                onPressed: () => LibraryService.remove(game.id),
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
