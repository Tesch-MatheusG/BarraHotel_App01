import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/usuario_mock_store.dart';
import '../models/usuario_model.dart';

class LoginViewModel {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<UsuarioModel?> login(String email, String senha) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Busca os dados extras do usuário no Firestore
      final doc = await _firestore
          .collection('usuarios')
          .doc(credential.user!.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        final perfil = data['perfil'] == 'master'
            ? PerfilUsuario.master
            : data['perfil'] == 'adm'
                ? PerfilUsuario.adm
                : PerfilUsuario.cliente;

        return UsuarioModel(
          nome: data['nome'] ?? '',
          email: data['email'] ?? '',
          senha: senha,
          cpf: data['cpf'] ?? '',
          telefone: data['telefone'] ?? '',
          cep: data['cep'] ?? '',
          rua: data['rua'] ?? '',
          bairro: data['bairro'] ?? '',
          numero: data['numero'] ?? '',
          complemento: data['complemento'] ?? '',
          estado: data['estado'] ?? '',
          municipio: data['municipio'] ?? '',
          perfil: perfil,
        );
      }

      return null;
    } catch (e) {
      // Fallback para o mock local (ADM master)
      return UsuarioMockStore.autenticar(email, senha);
    }
  }
}