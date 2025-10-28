import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import 'package:gerador_de_senha/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Monte as opções por plataforma usando as variáveis do .env
  final FirebaseOptions options = _firebaseOptionsForPlatform();

  await Firebase.initializeApp(options: options);
  runApp(const MyApp());
}

FirebaseOptions _firebaseOptionsForPlatform() {
  if (Platform.isAndroid) {
    return FirebaseOptions(
      apiKey: 'AIzaSyCZlEdEQwG-YgpbsgFXZjjCgdhoJF5IZVw',
      appId: '1:704660588087:android:c3cf7203e37ed00365a1b2',
      messagingSenderId: '704660588087',
      projectId: 'gerador-de-senha-a4cb8',
      storageBucket: 'gerador-de-senha-a4cb8.firebasestorage.app',
    );
  } else if (Platform.isIOS) {
    return FirebaseOptions(
      apiKey: 'AIzaSyCZlEdEQwG-YgpbsgFXZjjCgdhoJF5IZVw',
      appId: '1:704660588087:android:c3cf7203e37ed00365a1b2',
      messagingSenderId: '704660588087',
      projectId: 'gerador-de-senha-a4cb8',
      storageBucket: 'gerador-de-senha-a4cb8.firebasestorage.app',
      iosBundleId: 'com.yourcompany.geradordesenha', // ajuste seu bundle ID
    );
  } else if (Platform.isWindows) {
    return FirebaseOptions(
      apiKey: 'AIzaSyCZlEdEQwG-YgpbsgFXZjjCgdhoJF5IZVw',
      appId: '1:704660588087:android:c3cf7203e37ed00365a1b2',
      messagingSenderId: '704660588087',
      projectId: 'gerador-de-senha-a4cb8',
      authDomain: 'gerador-de-senha-a4cb8.firebaseapp.com',
      storageBucket: 'gerador-de-senha-a4cb8.firebasestorage.app',
    );
  }
  throw UnsupportedError(
    'Plataforma não suportada para configuração do Firebase',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gerador de senhas",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196F3),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF2196F3)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: Routes.splash,
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
