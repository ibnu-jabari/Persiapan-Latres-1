import 'package:flutter/material.dart';

import 'home_page.dart';
import 'library_page.dart';
import 'profile_page.dart';

/// Kerangka utama: BottomNavigationBar dengan 3 tab (Home, Library, Profile).
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  static const List<String> _judul = ['Browse Games', 'Library Anda', 'Profil'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_judul[_index])),
      // IndexedStack menjaga state tiap tab (daftar game tidak dimuat ulang).
      body: IndexedStack(
        index: _index,
        children: const [HomePage(), LibraryPage(), ProfilePage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Library',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
