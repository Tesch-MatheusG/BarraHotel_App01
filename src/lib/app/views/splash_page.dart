import 'package:flutter/material.dart';
import '../viewmodels/splash_viewmodel.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final vm = SplashViewModel();

  @override
  void initState() {
    super.initState();

    vm.iniciar(() {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // IMAGEM DE FUNDO
          SizedBox.expand(
            child: Image.asset(
              'assets/images/hotel.png',
              fit: BoxFit.cover,
            ),
          ),

          // OVERLAY
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

         // TEXTO CENTRAL
Center(
  child: Image.asset(
    'assets/images/logo.png', // caminho da logo
    width: 210, //
  ),
),
        ],
      ),
    );
  }
}