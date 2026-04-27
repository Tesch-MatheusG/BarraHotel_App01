import '../models/usuario_model.dart';

class UsuarioMockStore {


static List<UsuarioModel> _usuarios = [];

  static adicionarUsuario(UsuarioModel usuario) {
    _usuarios.add(usuario);
  }

  static UsuarioModel? autenticar(String email, String senha) {
    try {
      return _usuarios.firstWhere(
        (user) => user.email == email && user.senha == senha,
      );
    } catch (e) {
      return null;
    }
  }

static void atualizar(UsuarioModel atualizado) {
  final index = _usuarios.indexWhere(
    (u) => u.email == atualizado.email,
  );
  if (index != -1) {
    _usuarios[index] = atualizado;
  }
}
}