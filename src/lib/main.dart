import 'package:flutter/material.dart';
import 'app/views/splash_page.dart';
import 'app/views/login_page.dart';
import 'app/views/signup_page.dart';
import 'app/views/home_page.dart';
import 'app/views/Quarto/detalhequarto_page.dart';
import 'app/views/Quarto/lista_quartos_page.dart';
import 'app/views/Quarto/quartos_page.dart';
import 'app/views/reserva_page.dart';
import 'app/views/cores.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}