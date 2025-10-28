import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerador_de_senha/screens/intro/intro_screen.dart';
import 'package:gerador_de_senha/screens/login/login_screen.dart';
import 'package:gerador_de_senha/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndRedirect();
  }

  Future<void> _checkAuthAndRedirect() async {
    // Aguarda 3 segundos para mostrar a animação
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Verifica se o usuário está logado
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Usuário logado, vai para Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // Usuário não logado, verifica se deve mostrar intro
      final prefs = await SharedPreferences.getInstance();
      final shouldSkipIntro = prefs.getBool('skipIntro') ?? false;

      if (shouldSkipIntro) {
        // Pula intro, vai direto para login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        // Mostra intro
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const IntroScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animação Lottie centralizada (escudo com espada)
            Container(
              width: 200,
              height: 200,
              child: Lottie.asset(
                'assets/animations/shield_sword.json',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback caso a animação não exista
                  return const Icon(
                    Icons.security,
                    size: 120,
                    color: Colors.blue,
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Gerador de Senhas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Segurança em suas mãos',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
