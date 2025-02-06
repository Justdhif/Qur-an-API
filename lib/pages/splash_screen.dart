import 'package:flutter/material.dart';
import 'home_page.dart';  // Ganti dengan file PostPage Anda
import 'surah_page.dart';  // Ganti dengan file PostPage Anda

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Menunggu 3 detik sebelum berpindah ke halaman PostPage
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan gambar splash screen
            Image.asset(
              'assets/images/splash_image.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20), // Jarak antara gambar dan teks
            const Text(
              "The Holy Al-Qur'an",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20), // Jarak antara teks dan animasi loading
            // Animasi loading
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Loading...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
