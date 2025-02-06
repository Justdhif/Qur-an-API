import 'package:flutter/material.dart';
import '../services/http_service.dart';
import '../models/surah_model.dart';
import 'detail_page.dart';
import 'favorite_page.dart';

class PostPage extends StatefulWidget {
  final HttpService httpService = HttpService();

  PostPage({super.key});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<Surah> allSurahs = [];
  List<Surah> filteredSurahs = [];
  List<Surah> favoriteSurahs = [];
  String searchQuery = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchSurahs();
  }

  Future<void> _fetchSurahs() async {
    final surahs = await widget.httpService.getSurah();
    setState(() {
      allSurahs = surahs;
      filteredSurahs = surahs;
    });
  }

  void _filterSurahs(String query) {
    final filtered = allSurahs.where((surah) {
      return surah.nama.toLowerCase().contains(query.toLowerCase()) ||
             surah.namaLatin.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchQuery = query;
      filteredSurahs = filtered;
    });
  }

  void _toggleFavorite(Surah surah) {
    setState(() {
      if (favoriteSurahs.contains(surah)) {
        favoriteSurahs.remove(surah);
      } else {
        favoriteSurahs.add(surah);
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoritePage(favoriteSurahs: favoriteSurahs),
        ),
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
        title: const Text("The Holy Al-Qur'an", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: _filterSurahs,
              decoration: InputDecoration(
                labelText: 'Cari Surat',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search, color: Colors.blue[900]),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSurahs.length,
              itemBuilder: (context, index) {
                final surah = filteredSurahs[index];

                return Card(
                  color: Colors.blue[700],
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      "${surah.nomor} - ${surah.nama} ( ${surah.jumlahAyat} Ayat )",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "${surah.namaLatin} - ${surah.arti}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            favoriteSurahs.contains(surah) ? Icons.favorite : Icons.favorite_border,
                            color: favoriteSurahs.contains(surah) ? Colors.white : Colors.white,
                          ),
                          onPressed: () => _toggleFavorite(surah),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                      ],
                    ),
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
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Surah',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.favorite),
                if (favoriteSurahs.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '${favoriteSurahs.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Favorit',
          ),
          const BottomNavigationBarItem(
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
