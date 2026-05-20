import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../data/sessao.dart';
import '../models/usuario_model.dart';
import 'cores.dart';
import '../data/usuario_mock_store.dart';
import '../views/signup_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Página para o usuário editar seus dados cadastrais (exceto e-mail e CPF)
class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _formKey = GlobalKey<FormState>(); // chave para validar o formulário

  // Controllers dos campos editáveis
  late final TextEditingController _nome;
  late final TextEditingController _telefone;
  late final TextEditingController _cep;
  late final TextEditingController _rua;
  late final TextEditingController _bairro;
  late final TextEditingController _numero;
  late final TextEditingController _complemento;
  String? _estadoSelecionado;
  String? _municipioSelecionado;
  List<String> _municipios = [];
  bool _carregandoMunicipios = false;
  bool _carregandoCep = false;

  // Máscara de formatação para o campo de telefone
  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  // Máscara de formatação para o campo de CEP
  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    // Pré-preenche os campos com os dados atuais do usuário logado
    final usuario = Sessao.usuarioLogado;
      _nome = TextEditingController(text: usuario?.nome ?? '');
      _telefone = TextEditingController(text: usuario?.telefone ?? '');
      _cep = TextEditingController(text: usuario?.cep ?? '');
      _rua = TextEditingController(text: usuario?.rua ?? '');
      _bairro = TextEditingController(text: usuario?.bairro ?? '');
      _numero = TextEditingController(text: usuario?.numero ?? '');
      _complemento = TextEditingController(text: usuario?.complemento ?? '');
      _estadoSelecionado = usuario?.estado.isEmpty == true ? null : usuario?.estado;
      _municipioSelecionado = usuario?.municipio.isEmpty == true ? null : usuario?.municipio;

      // Carrega municípios do estado atual
      if (_estadoSelecionado != null) {
        _carregarMunicipios(_estadoSelecionado!);
      }
  }

  @override
  void dispose() {
    // Libera todos os controllers ao sair da página
    _nome.dispose();
    _telefone.dispose();
    _cep.dispose();
    _rua.dispose();
    _bairro.dispose();
    _numero.dispose();
    _complemento.dispose();
    super.dispose();
  }

  // Valida o formulário, atualiza a sessão e persiste no store
  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final atual = Sessao.usuarioLogado!;
      // Cria um novo modelo mantendo e-mail, senha e CPF inalterados
      final atualizado = UsuarioModel(
        nome: _nome.text,
        email: atual.email,
        senha: atual.senha,
        cpf: atual.cpf,
        telefone: _telefone.text,
        cep: _cep.text,
        rua: _rua.text,
        bairro: _bairro.text,
        numero: _numero.text,
        complemento: _complemento.text,
        estado: _estadoSelecionado ?? '',
        municipio: _municipioSelecionado ?? '',
      );
      
      Sessao.iniciar(atualizado); // atualiza a sessão com os novos dados
      UsuarioMockStore.atualizar(atualizado); // persiste a alteração no store

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // retorna para a página de perfil
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundoPagina,
      appBar: AppBar(
        backgroundColor: AppColors.azulEscuro,
        foregroundColor: Colors.white,
        title: const Text(
          'Alterar Cadastro',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edite suas informações',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),

              const SizedBox(height: 4),

              // Aviso de que e-mail e CPF são imutáveis
              const Text(
                'E-mail e CPF não podem ser alterados.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 16),

              // Campos editáveis do perfil
              _campo(
                controller: _nome,
                label: 'Nome Completo',
                icon: Icons.person_outline,
              ),
              _campo(
                controller: _telefone,
                label: 'Telefone',
                icon: Icons.phone_outlined,
                tipo: TextInputType.phone,
                mascara: _telefoneMask, // aplica máscara (##) #####-####
              ),
              _campo(
                controller: _cep,
                label: 'CEP',
                icon: Icons.location_on_outlined,
                tipo: TextInputType.number,
                mascara: _cepMask, // aplica máscara #####-###
              ),
              _campo(
                controller: _rua,
                label: 'Rua / Logradouro',
                icon: Icons.home_outlined,
              ),
              _campo(
                controller: _numero,
                label: 'Número',
                icon: Icons.tag,
              ),
              _campo(
                controller: _complemento,
                label: 'Complemento (opcional)',
                icon: Icons.info_outline,
                obrigatorio: false,
              ),

              const SizedBox(height: 24),

              // Botão de salvar — aciona a validação e persistência
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.azulEscuro,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Salvar Alterações',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builder de campo de formulário reutilizável com suporte a máscara e teclado customizado
  Widget _campo({
    required TextEditingController controller,
    bool obrigatorio = true,
    required String label,
    required IconData icon,
    TextInputType tipo = TextInputType.text, // padrão: teclado de texto
    MaskTextInputFormatter? mascara, // opcional — aplica formatação automática
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: tipo,
        inputFormatters: mascara != null ? [mascara] : [], // aplica a máscara se fornecida
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.azulEscuro, size: 20),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.cinzaBorda),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.cinzaBorda),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.azulEscuro,
              width: 1.5, // borda mais grossa ao focar no campo
            ),
          ),
        ),
        validator: (value) => obrigatorio && value!.isEmpty ? 'Campo obrigatório' : null, // validação simples
      ),
    );
  }
  // Busca municípios pelo estado selecionado via API do IBGE
  Future<void> _carregarMunicipios(String uf) async {
    setState(() {
      _carregandoMunicipios = true;
      _municipios = [];
      _municipioSelecionado = null;
    });

    try {
      final response = await http.get(Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$uf/municipios',
      ));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          _municipios = data.map((m) => m['nome'].toString()).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar municípios.')),
      );
    } finally {
      setState(() => _carregandoMunicipios = false);
    }
  }

}