import 'dart:async';

class SplashViewModel {

  Future<void> iniciar(Function navegar) async {

    await Future.delayed(Duration(seconds: 3));

    navegar();
  }
}