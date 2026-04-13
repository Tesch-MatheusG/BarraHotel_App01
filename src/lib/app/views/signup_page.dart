import 'package:flutter/material.dart';
import '../views/cores.dart';
import '../viewmodels/signup_viewmodel.dart';

// Página de cadastro de novo usuário.
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final _formKey = GlobalKey<FormState>();

  final vm = SignupViewModel();

  final nome = TextEditingController();
  final email = TextEditingController();
  final telefone = TextEditingController();
  final cpf = TextEditingController();
  final cep = TextEditingController();
  final endereco = TextEditingController();
  final senha = TextEditingController();
  final confirmarSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.azulEscuro,

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: AppColors.brancoCard,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Form(
            key: _formKey,
            child: Column(
              children: [

                Text(
                  'Criar Conta',
                  style: TextStyle(fontSize: 20),
                ),

                SizedBox(height: 5),

                Text('Preencha seus dados para se cadastrar'),

                SizedBox(height: 20),

                _campo(nome, 'Nome Completo'),
                _campo(email, 'Email'),
                _campo(telefone, 'Telefone'),
                _campo(cpf, 'CPF'),
                _campo(cep, 'CEP'),
                _campo(endereco, 'Endereço'),

                _campo(senha, 'Senha', isSenha: true),
                _campo(confirmarSenha, 'Confirmar Senha', isSenha: true),

                SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.azulBotao,
                    padding: EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                  ),
                  onPressed: () {

                    if (_formKey.currentState!.validate()) {

                      if (senha.text != confirmarSenha.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Senhas não coincidem')),
                        );
                        return;
                      }

                      vm.cadastrar(
                        nome.text,
                        email.text,
                        senha.text,
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo(TextEditingController controller, String hint,
      {bool isSenha = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isSenha,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: AppColors.cinzaCampo,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) =>
            value!.isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }
}