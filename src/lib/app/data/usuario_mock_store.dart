import '../models/usuario_model.dart';

class UsuarioMockStore {
  static List<UsuarioModel> _usuarios = [
    // ADM MASTER pré-cadastrado
    UsuarioModel(
      nome: 'Administrador Master',
      email: 'master@barrahotel.com',
      senha: 'master123',
      cpf: '000.000.000-00',
      telefone: '(00) 00000-0000',
      cep: '00000-000',
      endereco: 'Barra Hotel',
      perfil: PerfilUsuario.master,
    ),
  ];

  static void adicionarUsuario(UsuarioModel usuario) {
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

  static void atualizar(UsuarioModel atualizado) {
    final index = _usuarios.indexWhere(
      (u) => u.email == atualizado.email,
    );
    if (index != -1) {
      _usuarios[index] = atualizado;
    }
  }

  static void promover(String email, PerfilUsuario novoPerfil) {
    final index = _usuarios.indexWhere((u) => u.email == email);
    if (index != -1) {
      _usuarios[index] = _usuarios[index].copyWith(perfil: novoPerfil);
    }
  }

  static List<UsuarioModel> get clientes => _usuarios
      .where((u) => u.perfil == PerfilUsuario.cliente)
      .toList();

  static List<UsuarioModel> get adms => _usuarios
      .where((u) =>
          u.perfil == PerfilUsuario.adm ||
          u.perfil == PerfilUsuario.master)
      .toList();

  static List<UsuarioModel> get todos => List.unmodifiable(_usuarios);
}