import '../models/usuario_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Armazenamento temporário de usuários em memória (mock, sem banco de dados)
class UsuarioMockStore {
  static List<UsuarioModel> _usuarios = [
    // ADM MASTER pré-cadastrado — acesso total ao sistema
    UsuarioModel(
      nome: 'Administrador Master',
      email: dotenv.env['MASTER_EMAIL'] ?? '',
      senha: dotenv.env['MASTER_SENHA'] ?? '',
      cpf: '000.000.000-00',
      telefone: '(00) 00000-0000',
      cep: '00000-000',
      rua: 'Av. Manoel Gomes Casaca',
      bairro: 'Vila Santana',
      numero: '111',
      complemento: '',
      estado: 'SP',
      municipio: 'Vargem Grande do Sul',
      perfil: PerfilUsuario.master,
    ),
  ];

  // Adiciona um novo usuário à lista
  static void adicionarUsuario(UsuarioModel usuario) {
    _usuarios.add(usuario);
  }

  // Autentica o usuário pelo e-mail e senha, retorna null se não encontrar
  static UsuarioModel? autenticar(String email, String senha) {
    try {
      return _usuarios.firstWhere(
        (user) => user.email == email && user.senha == senha,
      );
    } catch (e) {
      return null; // credenciais inválidas ou usuário não encontrado
    }
  }

  // Atualiza os dados de um usuário existente buscando pelo e-mail
  static void atualizar(UsuarioModel atualizado) {
    final index = _usuarios.indexWhere(
      (u) => u.email == atualizado.email, // localiza pelo e-mail como chave
    );
    if (index != -1) {
      _usuarios[index] = atualizado; // substitui o registro antigo
    }
  }

  // Altera o perfil de acesso de um usuário (ex: cliente → adm)
  static void promover(String email, PerfilUsuario novoPerfil) {
    final index = _usuarios.indexWhere((u) => u.email == email);
    if (index != -1) {
      _usuarios[index] = _usuarios[index].copyWith(perfil: novoPerfil); // usa copyWith para preservar os outros dados
    }
  }

  // Retorna apenas os usuários com perfil de cliente
  static List<UsuarioModel> get clientes => _usuarios
      .where((u) => u.perfil == PerfilUsuario.cliente)
      .toList();

  // Retorna administradores e masters (usuários com acesso administrativo)
  static List<UsuarioModel> get adms => _usuarios
      .where((u) =>
          u.perfil == PerfilUsuario.adm ||
          u.perfil == PerfilUsuario.master)
      .toList();

  // Retorna todos os usuários como lista imutável (somente leitura)
  static List<UsuarioModel> get todos => List.unmodifiable(_usuarios);
}