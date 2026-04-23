import 'package:atividadep1/app/data/sessao.dart';
import 'package:flutter/material.dart';
import '../views/cores.dart';
import '../viewmodels/login_viewmodel.dart';


// PAGINA DE LOGIN DO APP
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

//CHAVES E CONTROLADORES
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  final vm = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.azulEscuro,

      body: Center(
        child: SingleChildScrollView(
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

                  // LOGO
                  Icon(Icons.wb_sunny, size: 40, color: Colors.orange),

                  SizedBox(height: 10),

                  Text(
                    'BARRA HOTEL',
                    style: TextStyle(
                      fontSize: 22,
                      letterSpacing: 3,
                      color: AppColors.azulEscuro,
                    ),
                  ),

                  SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                  SizedBox(height: 10),

                  // EMAIL
                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration('Email:'),
                    validator: (value) =>
                        value!.isEmpty ? 'Informe o email' : null,
                  ),

                  SizedBox(height: 15),

                  // SENHA
                  TextFormField(
                    controller: senhaController,
                    obscureText: true,
                    decoration: _inputDecoration('Senha:'),
                    validator: (value) =>
                        value!.isEmpty ? 'Informe a senha' : null,
                  ),

                  SizedBox(height: 20),

                  // BOTÃO
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.azulBotao,
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final user = vm.login(
                          emailController.text,
                          senhaController.text,
                        );

                        if (user != null) {
                          Sessao.iniciar(user);
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Login inválido')),
                          );
                        }
                      }
                    },
                    child: Text('Entrar'),
                  ),

                  SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      // TODO: implementar recuperação de senha via Firebase
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Em breve: recuperação de senha por e-mail.'),
                          backgroundColor: AppColors.azulEscuro,
                        ),
                      );
                    },
                    child: const Text(
                     'Esqueceu a senha?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: AppColors.azulEscuro,
                      ),
                    ),
                  ),

                  SizedBox(height: 5),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      'Não tem conta? Cadastre-se',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: AppColors.azulEscuro,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // DECORAÇÃO PADRÃO DOS CAMPOS
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.cinzaCampo,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}