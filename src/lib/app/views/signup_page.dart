import 'package:flutter/material.dart';
import '../views/cores.dart';
import '../viewmodels/signup_viewmodel.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// Página de cadastro de novo usuário
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  // Chave global para controle e validação do formulário
  final _formKey = GlobalKey<FormState>();

  // Instância do ViewModel responsável pela lógica de cadastro
  final vm = SignupViewModel();

  // Controladores para cada campo do formulário
  final nome = TextEditingController();
  final email = TextEditingController();
  final telefone = TextEditingController();
  final cpf = TextEditingController();
  final cep = TextEditingController();
  final endereco = TextEditingController();
  final senha = TextEditingController();
  final confirmarSenha = TextEditingController();

  // Máscara para o campo CPF no formato ###.###.###-##
  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  // Máscara para o campo telefone no formato (##) #####-####
  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  // Máscara para o campo CEP no formato #####-###
  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo azul escuro fora do card do formulário
      backgroundColor: AppColors.azulEscuro,

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),

          // Card branco com bordas arredondadas que contém o formulário
          decoration: BoxDecoration(
            color: AppColors.brancoCard,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Form(
            // Associa o formulário à chave de validação
            key: _formKey,
            child: Column(
              children: [

                // Título da página
                Text(
                  'Criar Conta',
                  style: TextStyle(fontSize: 20),
                ),

                SizedBox(height: 5),

                // Subtítulo orientando o usuário
                Text('Preencha seus dados para se cadastrar'),

                SizedBox(height: 20),

                // Campos do formulário, cada um usa o helper _campo
                _campo(nome, 'Nome Completo'),
                _campo(email, 'Email', tipo: TextInputType.emailAddress),
                // Campo telefone com teclado numérico e máscara
                _campo(telefone, 'Telefone', tipo: TextInputType.phone, mascara: _telefoneMask),
                // Campo CPF com teclado numérico e máscara
                _campo(cpf, 'CPF', tipo: TextInputType.number, mascara: _cpfMask),
                // Campo CEP com teclado numérico e máscara
                _campo(cep, 'CEP', tipo: TextInputType.number, mascara: _cepMask),
                _campo(endereco, 'Endereço'),
                // Campo senha com texto oculto
                _campo(senha, 'Senha', isSenha: true),
                // Campo de confirmação de senha também oculto
                _campo(confirmarSenha, 'Confirmar Senha', isSenha: true),

                SizedBox(height: 20),

                // Botão de envio do cadastro
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.azulBotao,
                    padding: EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                  ),
                  onPressed: () {

                    // Valida todos os campos antes de prosseguir
                    if (_formKey.currentState!.validate()) {

                      // Verifica se as senhas digitadas são iguais
                      if (senha.text != confirmarSenha.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Senhas não coincidem')),
                        );
                        return;
                      }

                      // Chama o ViewModel para registrar o novo usuário
                      vm.cadastrar(
                        nome.text,
                        email.text,
                        senha.text,
                        cpf.text,
                        telefone.text,
                        cep.text,
                        endereco.text,
                      );

                      // Volta para a tela anterior (login) após o cadastro
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

  // Helper que constrói um campo de texto padronizado com validação
  // Aceita máscara, tipo de teclado e modo senha opcionalmente
  Widget _campo(
    TextEditingController controller,
    String hint, {
    bool isSenha = false,
    TextInputType tipo = TextInputType.text,
    MaskTextInputFormatter? mascara,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        // Oculta o texto quando o campo é do tipo senha
        obscureText: isSenha,
        keyboardType: tipo,
        // Aplica a máscara de formatação se fornecida
        inputFormatters: mascara != null ? [mascara] : [],
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          // Fundo cinza claro para os campos
          fillColor: AppColors.cinzaCampo,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // Remove a borda visível padrão
            borderSide: BorderSide.none,
          ),
        ),
        // Valida se o campo está vazio
        validator: (value) =>
            value!.isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }
}