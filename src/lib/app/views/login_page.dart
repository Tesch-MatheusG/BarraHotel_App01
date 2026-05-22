import 'package:atividadep1/app/data/sessao.dart';
import 'package:flutter/material.dart';
import '../views/cores.dart';
import '../viewmodels/login_viewmodel.dart';
import '../models/usuario_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

 
// Página de login do app
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // Chave global para controle e validação do formulário
  final _formKey = GlobalKey<FormState>();

  // Controlador do campo de email
  final emailController = TextEditingController();
  // Controlador do campo de senha
  final senhaController = TextEditingController();

  // Instância do ViewModel responsável pela lógica de login
  final vm = LoginViewModel();

  // Controla o estado de carregamento enquanto aguarda o Firebase
  bool _carregando = false;

  // Método assíncrono separado para realizar o login
  Future<void> _fazerLogin() async {
    // Valida o formulário antes de tentar o login
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    // Chama o ViewModel com email e senha digitados
    final user = await vm.login(
      emailController.text,
      senhaController.text,
    );

    setState(() => _carregando = false);

    if (!mounted) return;

    if (user != null) {
      // Inicia a sessão com o usuário autenticado
      Sessao.iniciar(user);
      // Redireciona para área admin se for master ou adm
      if (user.perfil == PerfilUsuario.master ||
          user.perfil == PerfilUsuario.adm) {
        Navigator.pushReplacementNamed(context, '/adm');
      } else {
        // Redireciona para home se for hóspede comum
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      // Exibe mensagem de erro se as credenciais forem inválidas
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login inválido. Verifique e-mail e senha.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo azul escuro na área fora do card
      backgroundColor: AppColors.azulEscuro,

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),

            // Card branco com bordas arredondadas que envolve o formulário
            decoration: BoxDecoration(
              color: AppColors.brancoCard,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Form(
              // Associa o formulário à chave de validação
              key: _formKey,
              child: Column(
                children: [

                  // Logo do hotel
                  Image.asset(
                    'assets/images/sol.png',
                    width: 50
                  ),

                  SizedBox(height: 10),

                  // Nome do hotel em letras maiúsculas com espaçamento
                  Text(
                    'BARRA HOTEL',
                    style: TextStyle(
                      fontSize: 22,
                      letterSpacing: 3,
                      color: AppColors.azulEscuro,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Rótulo "Login" alinhado à esquerda
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Campo de e-mail com validação de campo vazio
                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration('Email:'),
                    validator: (value) =>
                        value!.isEmpty ? 'Informe o email' : null,
                  ),

                  SizedBox(height: 15),

                  // Campo de senha oculta com validação de campo vazio
                  TextFormField(
                    controller: senhaController,
                    obscureText: true,
                    decoration: _inputDecoration('Senha:'),
                    validator: (value) =>
                        value!.isEmpty ? 'Informe a senha' : null,
                  ),

                  SizedBox(height: 20),

                  // Botão de login — exibe indicador de carregamento enquanto aguarda o Firebase
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.azulBotao,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Desabilita o botão enquanto carrega
                    onPressed: _carregando ? null : _fazerLogin,
                    child: _carregando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Entrar'),
                  ),

                  SizedBox(height: 10),

                  // Link de recuperação de senha (funcionalidade futura)
                  GestureDetector(
                    onTap: () async {
                      final email = emailController.text.trim();
                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Digite seu e-mail antes de recuperar a senha.'),
                          ),
                        );
                        return;
                      }
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('E-mail de recuperação enviado!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Não foi possível enviar o e-mail. Verifique o endereço.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
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

                  // Link para a página de cadastro de novo usuário
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

  // Retorna a decoração padrão reutilizada em todos os campos do formulário
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      // Fundo cinza claro nos campos de texto
      fillColor: AppColors.cinzaCampo,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        // Remove a borda visível padrão
        borderSide: BorderSide.none,
      ),
    );
  }
}