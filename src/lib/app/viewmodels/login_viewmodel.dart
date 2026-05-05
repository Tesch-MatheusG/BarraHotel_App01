import '../data/usuario_mock_store.dart';
import '../models/usuario_model.dart'; 

// ViewModel responsável pela lógica de autenticação do login
class LoginViewModel {

  // Tenta autenticar o usuário e retorna o modelo se bem-sucedido, ou null se falhar
  UsuarioModel? login(String email, String senha) {
    return UsuarioMockStore.autenticar(email, senha);
  }
}