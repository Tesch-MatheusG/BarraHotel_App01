import 'package:flutter/material.dart';
import 'app/views/splash_page.dart';
import 'app/views/login_page.dart';
import 'app/views/signup_page.dart';
import 'app/views/home_page.dart';
import 'app/views/Quarto/quartos_page.dart';
import 'app/views/reserva_page.dart';
import 'app/views/perfil_page.dart';
import 'app/views/editar_perfil_page.dart';
import 'app/views/reservas/minhas_reservas_page.dart';
import 'app/views/chatbot_page.dart';

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
        '/perfil': (context) => PerfilPage(),
        '/editar-perfil': (context) => EditarPerfilPage(),
        '/minhas-reservas': (context) => MinhasReservasPage(),
        '/chatbot': (context) => ChatbotPage(),
      },
    );
  }
}