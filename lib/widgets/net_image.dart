import 'package:flutter/material.dart';

/// Gambar dari internet dengan placeholder saat loading dan saat gagal.
class NetImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const NetImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    const warna = Color(0xFF2C2C2E);

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(width: width, height: height, color: warna);
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: warna,
          child: const Icon(Icons.videogame_asset, color: Colors.grey),
        );
      },
    );
  }
}
