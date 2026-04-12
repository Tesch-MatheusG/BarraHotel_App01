import '../data/usuario_mock_store.dart';
import '../models/usuario_model.dart';

class LoginViewModel {

  UsuarioModel? login(String email, String senha) {

    return UsuarioMockStore.autenticar(email, senha);
  }
}