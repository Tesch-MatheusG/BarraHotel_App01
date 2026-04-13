import '../data/usuario_mock_store.dart';
import '../models/usuario_model.dart';

class SignupViewModel {

  void cadastrar(String nome, String email, String senha) {

    final usuario = UsuarioModel(
      nome: nome,
      email: email,
      senha: senha,
    );

    UsuarioMockStore.adicionarUsuario(usuario);
  }
}