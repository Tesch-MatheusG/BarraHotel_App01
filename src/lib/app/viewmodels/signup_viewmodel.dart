import '../data/usuario_mock_store.dart';
import '../models/usuario_model.dart';

class SignupViewModel {

  void cadastrar(
    String nome, 
    String email, 
    String senha,
    String cpf,
    String telefone,
    String cep,
    String endereco,
    ) {

    final usuario = UsuarioModel(
      nome: nome,
      email: email,
      senha: senha,
      cpf: cpf,
      telefone: telefone,
      cep: cep,
      endereco: endereco,
    );

    UsuarioMockStore.adicionarUsuario(usuario);
  }
}