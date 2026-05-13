import 'package:flutter/material.dart';
import '../viewmodels/splash_viewmodel.dart';

// Tela de splash exibida na inicialização do app
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // Instância do ViewModel que controla o tempo de exibição da splash
  final vm = SplashViewModel();

  @override
  void initState() {
    super.initState();

    // Inicia o temporizador e navega para a tela de login ao concluir
    vm.iniciar(() {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // Imagem de fundo ocupando toda a tela
          SizedBox.expand(
            child: Image.asset(
              'assets/images/hotel.png',
              fit: BoxFit.cover,
            ),
          ),

          // Camada escura semitransparente sobre a imagem para melhorar o contraste
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          // Logo do hotel centralizada sobre o overlay
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 210,
            ),
          ),
        ],
      ),
    );
  }
}