enum PerfilUsuario { cliente, adm, master }

class UsuarioModel {
  final String nome;
  final String email;
  final String senha;
  final String cpf;
  final String telefone;
  final String cep;
  final String endereco;
  final PerfilUsuario perfil;

  UsuarioModel({
    required this.nome,
    required this.email,
    required this.senha,
    required this.cpf,
    required this.telefone,
    required this.cep,
    required this.endereco,
    this.perfil = PerfilUsuario.cliente,
  });

  UsuarioModel copyWith({PerfilUsuario? perfil}) {
    return UsuarioModel(
      nome: nome,
      email: email,
      senha: senha,
      cpf: cpf,
      telefone: telefone,
      cep: cep,
      endereco: endereco,
      perfil: perfil ?? this.perfil,
    );
  }
}