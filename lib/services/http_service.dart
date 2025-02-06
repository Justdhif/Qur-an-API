import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah_model.dart';

class HttpService {
  Future<List<Surah>> getSurah() async {
    final response = await http.get(Uri.parse('https://quran-api.santrikoding.com/api/surah'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data.map((json) => Surah.fromJson(json)).toList();
      } else {
        throw Exception("Unexpected JSON format: Expected a List but got ${data.runtimeType}");
      }
    } else {
      throw Exception("Failed to load surahs");
    }
  }
}
