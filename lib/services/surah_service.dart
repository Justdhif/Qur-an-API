import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah_model.dart';

Future<List<Surah>> fetchSurahList() async {
  final response = await http.get(Uri.parse("https://quran-api.santrikoding.com/api/surah"));

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((json) => Surah.fromJson(json)).toList();
  } else {
    throw Exception("Gagal mengambil daftar surah");
  }
}
