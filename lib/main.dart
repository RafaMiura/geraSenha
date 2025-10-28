import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gerador_de_senha/screens/splash/splash_screen.dart';
import 'package:gerador_de_senha/firebase_options.dart';
import 'package:gerador_de_senha/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseConfig.initialize();
    print('🚀 App inicializado com sucesso!');
  } catch (e) {
    print('❌ Erro ao inicializar app: $e');
  }

  runApp(const PasswordApp());
}

class PasswordApp extends StatelessWidget {
  const PasswordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
