import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail_page.dart';
import 'surah_page.dart';
import 'favorite_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> surahList = [];
  Map<String, dynamic>? prayerTimes;

  @override
  void initState() {
    super.initState();
    fetchSurahList();
    fetchPrayerTimes();
  }

  Future<void> fetchSurahList() async {
    final response = await http.get(Uri.parse("https://equran.id/api/v2/surat"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> allSurahs = data['data'];
      allSurahs.shuffle(Random());
      setState(() {
        surahList = allSurahs.take(6).toList(); // Ambil 6 surah secara acak
      });
    }
  }

  Future<void> fetchPrayerTimes() async {
    final response = await http.get(
      Uri.parse("https://api.aladhan.com/v1/timingsByCity?city=Jakarta&country=Indonesia&method=2"),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        prayerTimes = data['data']['timings'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quran & Prayer Times", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Waktu Sholat (Jakarta)", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
              SizedBox(height: 10),
              prayerTimes == null
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade900, Colors.blue.shade400],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        children: prayerTimes!.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(entry.key, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                Text(entry.value, style: TextStyle(fontSize: 18, color: Colors.white)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
              SizedBox(height: 20),
              Text("Daftar Surah (Acak)", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
              SizedBox(height: 10),
              surahList.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 surah dalam satu baris
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: surahList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailSurahPage(surahNumber: surahList[index]['nomor']),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: Colors.teal.shade100,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(surahList[index]['nama'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5),
                                  Text("Ayat: ${surahList[index]['jumlahAyat']}", style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Surah"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostPage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritePage(favoriteSurahs: [],)),
            );
          }
        },
      ),
    );
  }
}
