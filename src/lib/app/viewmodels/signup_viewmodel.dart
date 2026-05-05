import '../data/usuario_mock_store.dart';
import '../models/usuario_model.dart';

// ViewModel responsável pela lógica de cadastro de novos usuários
class SignupViewModel {

  // Cria e registra um novo usuário com os dados informados no formulário
  void cadastrar(
    String nome, 
    String email, 
    String senha,
    String cpf,
    String telefone,
    String cep,
    String endereco,
    ) {

    // Cria o modelo de usuário com perfil padrão de cliente
    final usuario = UsuarioModel(
      nome: nome,
      email: email,
      senha: senha,
      cpf: cpf,
      telefone: telefone,
      cep: cep,
      endereco: endereco,
    );

    UsuarioMockStore.adicionarUsuario(usuario); // persiste o novo usuário no store
  }
}