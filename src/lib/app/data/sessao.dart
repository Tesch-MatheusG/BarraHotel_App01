import '../models/usuario_model.dart';

// Gerencia a sessão do usuário logado no app (armazenamento em memória)
class Sessao {
  static UsuarioModel? usuarioLogado; // usuário atual, nulo se não houver sessão ativa

  // Inicia a sessão armazenando o usuário logado
  static void iniciar(UsuarioModel usuario) {
    usuarioLogado = usuario;
  }

  // Encerra a sessão limpando o usuário logado
  static void encerrar() {
    usuarioLogado = null;
  }
}