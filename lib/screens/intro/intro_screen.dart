import 'package:flutter/material.dart';
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
      'title': 'Bem-vindo!',
      'subtitle': 'Gerencie suas senhas com segurança.',
      'anim': 'assets/animations/security.json',
    },
    {
      'title': 'Organize-se',
      'subtitle': 'Salve e acesse suas senhas em qualquer lugar.',
      'anim': 'assets/animations/cloud.json',
    },
    {
      'title': 'Tudo pronto!',
      'subtitle': 'Vamos começar?',
      'anim': 'assets/animations/start.json',
    },
  ];
  
  get SharedPreferences => null;
  
  get Lottie => null;

  Future<void> _finishIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('skipIntro', dontShowAgain);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Lottie.asset(page['anim']!, height: 220),
                Text(
                  page['title']!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(page['subtitle']!, textAlign: TextAlign.center),
                if (i == pages.length - 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: dontShowAgain,
                        onChanged: (v) => setState(() => dontShowAgain = v!),
                      ),
                      const Text('Não mostrar novamente'),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (pageIndex > 0)
              TextButton(
                onPressed: () => setState(() => pageIndex--),
                child: const Text('Voltar'),
              ),
            ElevatedButton(
              onPressed: pageIndex == pages.length - 1
                  ? _finishIntro
                  : () => setState(() => pageIndex++),
              child: Text(
                pageIndex == pages.length - 1 ? 'Concluir' : 'Avançar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}


