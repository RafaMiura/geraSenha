import 'package:flutter/material.dart';
import 'package:gerador_de_senha/core/auth_guard.dart';
import 'package:gerador_de_senha/screens/home/home_screen.dart';
import 'package:gerador_de_senha/screens/intro/intro_screen.dart';
import 'package:gerador_de_senha/screens/login/login_screen.dart';
import 'package:gerador_de_senha/screens/password/password_screen.dart';
import 'package:gerador_de_senha/screens/splash/splash_screen.dart';


class Routes {
  static const String splash = '/';
  static const String home = '/home';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String password = '/password';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case intro:
        return MaterialPageRoute(builder: (_) => IntroScreen());
      case home:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: HomeScreen()),
        );
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case password:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: NewPasswordScreen()),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text("Rota não encontrada!"))),
        );
    }
  }
}
