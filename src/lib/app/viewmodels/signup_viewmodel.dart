import 'package:firebase_auth/firebase_auth.dart';
import '../data/usuario_mock_store.dart';
import '../models/usuario_model.dart';

// ViewModel responsável pela lógica de cadastro de novos usuários
class SignupViewModel {

  // Instância do FirebaseAuth para criação de conta
  final _auth = FirebaseAuth.instance;

  // Cria e registra um novo usuário no Firebase e no mock local
  Future<bool> cadastrar(
    String nome,
    String email,
    String senha,
    String cpf,
    String telefone,
    String cep,
    String endereco,
  ) async {
    try {
      // Cria o usuário no Firebase Authentication com email e senha
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Atualiza o nome de exibição do usuário no Firebase
      await credential.user?.updateDisplayName(nome);

      // Cria o modelo local com perfil padrão de cliente
      final usuario = UsuarioModel(
        nome: nome,
        email: email,
        senha: senha,
        cpf: cpf,
        telefone: telefone,
        cep: cep,
        endereco: endereco,
      );

      // Persiste o novo usuário no mock store local
      UsuarioMockStore.adicionarUsuario(usuario);

      return true; // cadastro realizado com sucesso
    } catch (e) {
      return false; // erro no Firebase (email já cadastrado, senha fraca, etc.)
    }
  }
}