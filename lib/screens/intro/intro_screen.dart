import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gerador_de_senha/screens/login/login_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int pageIndex = 0;
  bool dontShowAgain = false;

  final List<Map<String, String>> pages = [
    {
      'title': 'Bem-vindo ao App',
      'subtitle': 'Aproveite o seu gerenciamento de senhas',
      'anim': 'assets/animations/welcome.json',
    },
    {
      'title': 'Funcionalidades',
      'subtitle': 'Explore diversas funcionalidades',
      'anim': 'assets/animations/features.json',
    },
    {
      'title': 'Vamos começar?',
      'subtitle': 'Pronto para usar o gerenciador com segurança?',
      'anim': 'assets/animations/start.json',
    },
  ];

  Future<void> _finishIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('skipIntro', dontShowAgain);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: PageView.builder(
        itemCount: pages.length,
        onPageChanged: (i) => setState(() => pageIndex = i),
        itemBuilder: (_, i) {
          final page = pages[i];
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animação Lottie centralizada
                Container(
                  width: 250,
                  height: 250,
                  child: Lottie.asset(
                    page['anim']!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback para cada página
                      IconData iconData;
                      switch (i) {
                        case 0:
                          iconData = Icons.security;
                          break;
                        case 1:
                          iconData = Icons.fitness_center;
                          break;
                        case 2:
                          iconData = Icons.lock_open;
                          break;
                        default:
                          iconData = Icons.security;
                      }
                      return Icon(iconData, size: 120, color: Colors.blue);
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  page['title']!,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  page['subtitle']!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Checkbox apenas na última página
                if (i == pages.length - 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: dontShowAgain,
                        onChanged: (v) => setState(() => dontShowAgain = v!),
                        activeColor: Colors.blue,
                      ),
                      const Text(
                        'Não mostrar essa introdução novamente',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botão Voltar (apenas se não for a primeira página)
            if (pageIndex > 0)
              TextButton(
                onPressed: () => setState(() => pageIndex--),
                child: const Text(
                  'Voltar',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              )
            else
              const SizedBox(width: 60), // Espaçamento para manter alinhamento
            // Botão Avançar/Concluir
            ElevatedButton(
              onPressed: pageIndex == pages.length - 1
                  ? _finishIntro
                  : () => setState(() => pageIndex++),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                pageIndex == pages.length - 1 ? 'Concluir' : 'Avançar',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Botão Pular (apenas se não for a última página)
            if (pageIndex < pages.length - 1)
              TextButton(
                onPressed: _finishIntro,
                child: const Text(
                  'Pular',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
            else
              const SizedBox(width: 60), // Espaçamento para manter alinhamento
          ],
        ),
      ),
    );
  }
}
