import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class DetailSurahPage extends StatefulWidget {
  final int surahNumber;

  const DetailSurahPage({Key? key, required this.surahNumber}) : super(key: key);

  @override
  _DetailSurahPageState createState() => _DetailSurahPageState();
}

class _DetailSurahPageState extends State<DetailSurahPage> {
  Map<String, dynamic>? surahData;
  bool isLoading = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? playingAyat;

  @override
  void initState() {
    super.initState();
    fetchSurahDetails();
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          playingAyat = null;
        });
      }
    });
  }

  Future<void> fetchSurahDetails() async {
    final url = Uri.parse('https://equran.id/api/v2/surat/${widget.surahNumber}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        surahData = json.decode(response.body)['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> playAudio(String url, int ayatNumber) async {
    try {
      if (playingAyat == ayatNumber) {
        await _audioPlayer.stop();
        setState(() {
          playingAyat = null;
        });
      } else {
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));
        await _audioPlayer.play();
        setState(() {
          playingAyat = ayatNumber;
        });
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surahData?['nama'] ?? 'Loading...', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : surahData == null
              ? const Center(child: Text('Gagal memuat data'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${surahData!['nama']} (${surahData!['namaLatin']})',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        'Diturunkan: ${surahData!['tempatTurun']}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70),
                      ),
                      Text(
                        'Jumlah Ayat: ${surahData!['jumlahAyat']}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: surahData!['ayat'].length,
                          itemBuilder: (context, index) {
                            var ayat = surahData!['ayat'][index];
                            return Card(
                              color: Colors.blue[700],
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border: Border.all(color: Colors.blue[900]!, width: 2),
                                          ),
                                          child: Center(
                                            child: Text(
                                              ayat['nomorAyat'].toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue[900]),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            ayat['teksArab'],
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            playingAyat == ayat['nomorAyat']
                                                ? Icons.pause_circle_filled
                                                : Icons.play_circle_fill,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            if (ayat['audio'] != null && ayat['audio']['01'] != null) {
                                              playAudio(ayat['audio']['01'], ayat['nomorAyat']);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      ayat['teksLatin'],
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      ayat['teksIndonesia'],
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      backgroundColor: Colors.blue[900],
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
