import 'dart:async';

// ViewModel responsável pela lógica da tela de splash (abertura do app)
class SplashViewModel {

  // Aguarda 3 segundos e dispara a navegação para a próxima tela
  Future<void> iniciar(Function navegar) async {

    await Future.delayed(Duration(seconds: 3)); // pausa antes de navegar

    navegar(); // executa o callback de navegação passado pela view
  }
}