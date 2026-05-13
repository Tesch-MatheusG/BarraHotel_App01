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
    String endereco,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await credential.user?.updateDisplayName(nome);

      // Salva os dados extras no Firestore
      await _firestore
          .collection('usuarios')
          .doc(credential.user!.uid)
          .set({
        'nome': nome,
        'email': email,
        'cpf': cpf,
        'telefone': telefone,
        'cep': cep,
        'endereco': endereco,
        'perfil': 'cliente',
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}