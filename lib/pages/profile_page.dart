import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/library_service.dart';
import '../services/session_service.dart';
import 'login_page.dart';

/// Tab Profil: email (SharedPreferences), jumlah game (Hive), dan logout.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    await SessionService.logout();
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Widget _baris(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 55,
              backgroundColor: Color(0xFF3A3A3C),
              child: Icon(Icons.person, size: 60, color: Colors.white70),
            ),
            const SizedBox(height: 32),
            // Email dari SharedPreferences
            _baris('Email', SessionService.email),
            const SizedBox(height: 8),
            // Jumlah game dari Hive (ikut berubah kalau library berubah)
            ValueListenableBuilder<Box>(
              valueListenable: LibraryService.listenable,
              builder: (context, box, _) {
                return _baris('Games Dimiliki', '${LibraryService.count}');
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const StadiumBorder(),
                ),
                onPressed: () => _logout(context),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
