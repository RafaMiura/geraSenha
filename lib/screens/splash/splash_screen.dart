import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerador_de_senha/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNextScreen();
  }

  Future<void> _handleNextScreen() async {
    // Exibe o splash por 2 segundos
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final showIntro = prefs.getBool('show_intro') ?? true;

    // Aguarda o FirebaseAuth inicializar e retornar o estado atual
    final user = await FirebaseAuth.instance.authStateChanges().first;
    debugPrint('SplashScreen → Usuário: ${user?.uid ?? "não logado"}');

    if (!mounted) return;

    if (showIntro) {
      Navigator.pushReplacementNamed(context, Routes.intro);
    } else if (user != null) {
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      Navigator.pushReplacementNamed(context, Routes.login);
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
            // Animação Lottie (com fallback)
            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                'assets/animations/shield_sword.json',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
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
