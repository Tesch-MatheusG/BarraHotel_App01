import 'package:firebase_auth/firebase_auth.dart';
import '../data/usuario_mock_store.dart';
import '../models/usuario_model.dart';

// ViewModel responsável pela lógica de autenticação do login
class LoginViewModel {

  // Instância do FirebaseAuth para autenticação
  final _auth = FirebaseAuth.instance;

  // Tenta autenticar o usuário no Firebase e retorna o modelo local se bem-sucedido
  Future<UsuarioModel?> login(String email, String senha) async {
    try {
      // Realiza o login no Firebase com email e senha
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      // Se autenticou no Firebase, busca o usuário no mock local para manter os dados de perfil
      return UsuarioMockStore.autenticar(email, senha);
    } catch (e) {
      // Retorna null em caso de credenciais inválidas ou erro de rede
      return null;
    }
  }
}