import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, String>> fetchPrayerTimes() async {
  final url = "https://api.aladhan.com/v1/timingsByCity?city=Jakarta&country=Indonesia&method=2";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return {
      "Fajr": data['data']['timings']['Fajr'],
      "Dhuhr": data['data']['timings']['Dhuhr'],
      "Asr": data['data']['timings']['Asr'],
      "Maghrib": data['data']['timings']['Maghrib'],
      "Isha": data['data']['timings']['Isha'],
    };
  } else {
    throw Exception("Gagal mengambil data waktu sholat");
  }
}
