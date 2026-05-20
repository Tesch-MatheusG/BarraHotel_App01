enum PerfilUsuario { cliente, adm, master }

class UsuarioModel {
  final String nome;
  final String email;
  final String senha;
  final String cpf;
  final String telefone;
  final String cep;
  final String rua;
  final String bairro;
  final String numero;
  final String complemento;
  final String estado;
  final String municipio;
  final PerfilUsuario perfil;

  UsuarioModel({
    required this.nome,
    required this.email,
    required this.senha,
    required this.cpf,
    required this.telefone,
    required this.cep,
    required this.rua,
    required this.bairro,
    required this.numero,
    this.complemento = '',
    this.estado = '',
    this.municipio = '',
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
      rua: rua,
      bairro: bairro,
      numero: numero,
      complemento: complemento,
      estado: estado,
      municipio: municipio,
      perfil: perfil ?? this.perfil,
    );
  }
}