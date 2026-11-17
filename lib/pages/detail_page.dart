import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/game.dart';
import '../services/api_service.dart';
import '../services/library_service.dart';
import '../widgets/net_image.dart';

/// Detail game. Data diambil dari API berdasarkan [gameId].
class DetailPage extends StatefulWidget {
  final int gameId;

  const DetailPage({super.key, required this.gameId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<GameDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchGameDetail(widget.gameId);
  }

  void _muatUlang() {
    setState(() {
      _future = ApiService.fetchGameDetail(widget.gameId);
    });
  }

  Widget _tag(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _info(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Tombol "Get" (belum dimiliki) atau "In Library" (sudah dimiliki).
  Widget _tombolGet(GameDetail game) {
    return ValueListenableBuilder<Box>(
      valueListenable: LibraryService.listenable,
      builder: (context, box, _) {
        final dimiliki = LibraryService.contains(game.id);

        return SizedBox(
          width: double.infinity,
          child: dimiliki
              ? FilledButton.icon(
                  onPressed: null, // nonaktif, tampil abu-abu
                  icon: const Icon(Icons.check),
                  label: const Text('In Library'),
                )
              : FilledButton.icon(
                  onPressed: () {
                    LibraryService.add(game.toGame());
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('${game.title} ditambahkan ke library'),
                          backgroundColor: Colors.green,
                        ),
                      );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Get'),
                ),
        );
      },
    );
  }

  Widget _isi(GameDetail game) {
    return ListView(
      children: [
        // Hero image: paling atas dan besar
        AspectRatio(
          aspectRatio: 16 / 9,
          child: NetImage(url: game.thumbnail, width: double.infinity),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Genre dan platform
              Row(children: [_tag(game.genre), _tag(game.platform)]),
              const SizedBox(height: 12),
              // Nama game
              Text(
                game.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // Tanggal rilis, publisher, developer
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _info('Release Date', game.releaseDate),
                  _info('Publisher', game.publisher),
                  _info('Developer', game.developer),
                ],
              ),
              const SizedBox(height: 16),
              _tombolGet(game),
              // Screenshots
              if (game.screenshots.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  'Screenshots',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: game.screenshots.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: NetImage(
                          url: game.screenshots[index],
                          width: 190,
                          height: 110,
                        ),
                      );
                    },
                  ),
                ),
              ],
              // Deskripsi
              const SizedBox(height: 20),
              const Text(
                'Overview',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                game.description,
                style: const TextStyle(color: Colors.white70, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tombol kembali (panah) otomatis ada di AppBar.
      appBar: AppBar(title: const Text('Detail')),
      body: FutureBuilder<GameDetail>(
        future: _future,
        builder: (context, snapshot) {
          // Loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Gagal memuat detail game. Periksa koneksi internet.',
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

          return _isi(snapshot.data!);
        },
      ),
    );
  }
}
