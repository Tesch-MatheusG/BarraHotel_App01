import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/views/splash_page.dart';
import 'app/views/login_page.dart';
import 'app/views/signup_page.dart';
import 'app/views/home_page.dart';
import 'app/views/quarto/quartos_page.dart';
import 'app/views/reserva_page.dart';
import 'app/views/perfil_page.dart';
import 'app/views/editar_perfil_page.dart';
import 'app/views/reservas/minhas_reservas_page.dart';
import 'app/views/chatbot_page.dart';
import 'app/views/adm/adm_home_page.dart';
import 'firebase_options.dart';

void main() async {
  // Garante que os bindings do Flutter estejam prontos antes de inicializar o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa o Firebase antes de rodar o app
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(const MyApp());
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
        '/adm': (context) => AdmHomePage(),
      },
    );
  }
}