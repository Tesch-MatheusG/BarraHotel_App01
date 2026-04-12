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
}