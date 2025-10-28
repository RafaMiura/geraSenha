import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      print('✅ Firebase inicializado com sucesso!');

      // Configurar Firestore para usar emulador (opcional para desenvolvimento)
      // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

      // Configurar Auth para usar emulador (opcional para desenvolvimento)
      // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      print('❌ Erro ao inicializar Firebase: $e');
      rethrow;
    }
  }

  static Future<void> enableAuthEmulator() async {
    try {
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      print('✅ Auth Emulator configurado!');
    } catch (e) {
      print('❌ Erro ao configurar Auth Emulator: $e');
    }
  }

  static Future<void> enableFirestoreEmulator() async {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      print('✅ Firestore Emulator configurado!');
    } catch (e) {
      print('❌ Erro ao configurar Firestore Emulator: $e');
    }
  }
}
