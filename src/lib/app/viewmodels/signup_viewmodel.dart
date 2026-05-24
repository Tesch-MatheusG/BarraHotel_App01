import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';

class SignupViewModel {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

    Future<bool> cadastrar(
    String nome,
    String email,
    String senha,
    String cpf,
    String telefone,
    String cep,
    String rua,
    String bairro,
    String numero,
    String complemento,
    String estado,
    String municipio,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await credential.user?.updateDisplayName(nome);

      await _firestore
          .collection('usuarios')
          .doc(credential.user!.uid)
          .set({
        'nome': nome,
        'email': email,
        'cpf': cpf,
        'telefone': telefone,
        'cep': cep,
        'rua': rua,
        'bairro': bairro,
        'numero': numero,
        'complemento': complemento,
        'estado': estado,
        'municipio': municipio,
        'perfil': 'cliente',
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}