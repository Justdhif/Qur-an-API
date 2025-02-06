import 'package:flutter/material.dart';
import '../models/surah_model.dart';
import 'detail_page.dart';
import 'surah_page.dart';

class FavoritePage extends StatefulWidget {
  final List<Surah> favoriteSurahs;

  const FavoritePage({super.key, required this.favoriteSurahs});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PostPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Surah Favorit (${widget.favoriteSurahs.length})",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: widget.favoriteSurahs.isEmpty
          ? const Center(
              child: Text("Belum ada surat favorit", style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: widget.favoriteSurahs.length,
              itemBuilder: (context, index) {
                final surah = widget.favoriteSurahs[index];

                return Card(
                  color: Colors.blue[700],
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      "${surah.nomor} - ${surah.nama}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "${surah.namaLatin} - ${surah.arti}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailSurahPage(surahNumber: surah.nomor),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Surah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
        onTap: _onItemTapped,
      ),
    );
  }
}
