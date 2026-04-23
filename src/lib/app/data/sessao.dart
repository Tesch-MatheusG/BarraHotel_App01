import '../models/usuario_model.dart';

class Sessao {
  static UsuarioModel? usuarioLogado;

  static void iniciar(UsuarioModel usuario) {
    usuarioLogado = usuario;
  }

  static void encerrar() {
    usuarioLogado = null;
  }
}