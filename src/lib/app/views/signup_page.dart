import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../views/cores.dart';
import '../viewmodels/signup_viewmodel.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final vm = SignupViewModel();

  // Controllers dos campos
  final nome = TextEditingController();
  final email = TextEditingController();
  final telefone = TextEditingController();
  final cpf = TextEditingController();
  final cep = TextEditingController();
  final rua = TextEditingController();
  final bairro = TextEditingController();
  final numero = TextEditingController();
  final complemento = TextEditingController();
  final senha = TextEditingController();
  final confirmarSenha = TextEditingController();

  // Estado e Município selecionados
  String? _estadoSelecionado;
  String? _municipioSelecionado;

  // Listas para os dropdowns
  final List<Map<String, String>> _estados = [
    {'sigla': 'AC', 'nome': 'Acre'},
    {'sigla': 'AL', 'nome': 'Alagoas'},
    {'sigla': 'AP', 'nome': 'Amapá'},
    {'sigla': 'AM', 'nome': 'Amazonas'},
    {'sigla': 'BA', 'nome': 'Bahia'},
    {'sigla': 'CE', 'nome': 'Ceará'},
    {'sigla': 'DF', 'nome': 'Distrito Federal'},
    {'sigla': 'ES', 'nome': 'Espírito Santo'},
    {'sigla': 'GO', 'nome': 'Goiás'},
    {'sigla': 'MA', 'nome': 'Maranhão'},
    {'sigla': 'MT', 'nome': 'Mato Grosso'},
    {'sigla': 'MS', 'nome': 'Mato Grosso do Sul'},
    {'sigla': 'MG', 'nome': 'Minas Gerais'},
    {'sigla': 'PA', 'nome': 'Pará'},
    {'sigla': 'PB', 'nome': 'Paraíba'},
    {'sigla': 'PR', 'nome': 'Paraná'},
    {'sigla': 'PE', 'nome': 'Pernambuco'},
    {'sigla': 'PI', 'nome': 'Piauí'},
    {'sigla': 'RJ', 'nome': 'Rio de Janeiro'},
    {'sigla': 'RN', 'nome': 'Rio Grande do Norte'},
    {'sigla': 'RS', 'nome': 'Rio Grande do Sul'},
    {'sigla': 'RO', 'nome': 'Rondônia'},
    {'sigla': 'RR', 'nome': 'Roraima'},
    {'sigla': 'SC', 'nome': 'Santa Catarina'},
    {'sigla': 'SP', 'nome': 'São Paulo'},
    {'sigla': 'SE', 'nome': 'Sergipe'},
    {'sigla': 'TO', 'nome': 'Tocantins'},
  ];

  List<String> _municipios = [];
  bool _carregandoMunicipios = false;
  bool _carregandoCep = false;
  bool _carregando = false;

  void _mostrarCepNaoEncontrado() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CEP não encontrado.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Máscaras
  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );
  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );
  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp(r'[0-9]')},
  );

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

      if (!mounted) return;

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          _municipios = data.map((m) => m['nome'].toString()).toList();
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar municípios.')),
      );
    } finally {
      if (mounted) {
        setState(() => _carregandoMunicipios = false);
      }
    }
  }

  // Busca endereço pelo CEP via ViaCEP e preenche os campos automaticamente
  Future<void> _buscarCep(String cepDigitado) async {
    final cepLimpo = cepDigitado.replaceAll(RegExp(r'[^0-9]'), '');
    if (cepLimpo.length != 8) {
      _mostrarCepNaoEncontrado();
      return;
    }

    setState(() => _carregandoCep = true);

    try {
      final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cepLimpo/json/'),
      );
      if (!mounted) return;

      if (response.statusCode != 200) {
        _mostrarCepNaoEncontrado();
        return;
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is! Map<String, dynamic> || data['erro'] == true) {
          _mostrarCepNaoEncontrado();
          return;
        }

        // Preenche os campos automaticamente
        rua.text = data['logradouro'] ?? '';
        bairro.text = data['bairro'] ?? '';

        // Seleciona o estado automaticamente
        final uf = data['uf']?.toString() ?? '';
        if (uf.isEmpty) {
          _mostrarCepNaoEncontrado();
          return;
        }
        setState(() => _estadoSelecionado = uf);

        // Carrega e seleciona o município automaticamente
        await _carregarMunicipios(uf);
        if (!mounted) return;

        final cidade = data['localidade']?.toString() ?? '';
        if (cidade.isEmpty) {
          _mostrarCepNaoEncontrado();
          return;
        }
        setState(() => _municipioSelecionado = cidade);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Endereço preenchido automaticamente!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _mostrarCepNaoEncontrado();
    } finally {
      if (mounted) {
        setState(() => _carregandoCep = false);
      }
    }
  }

  Future<void> _fazerCadastro() async {
    if (!_formKey.currentState!.validate()) return;

    if (senha.text != confirmarSenha.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senhas não coincidem')),
      );
      return;
    }

    if (_estadoSelecionado == null || _municipioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione o estado e município.')),
      );
      return;
    }

    setState(() => _carregando = true);

    final sucesso = await vm.cadastrar(
      nome.text,
      email.text,
      senha.text,
      cpf.text,
      telefone.text,
      cep.text,
      rua.text,
      bairro.text,
      numero.text,
      complemento.text,
      _estadoSelecionado!,
      _municipioSelecionado!,
    );

    setState(() => _carregando = false);

    if (!mounted) return;

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erro ao cadastrar. Verifique se o e-mail já está em uso '
            'ou se a senha tem no mínimo 6 caracteres.',
          ),
          backgroundColor: Color(0xFFC40000),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.azulEscuro,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.brancoCard,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // TÍTULO
                const Center(
                  child: Text(
                    'Criar Conta',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const Center(
                  child: Text('Preencha seus dados para se cadastrar'),
                ),
                const SizedBox(height: 20),

                // DADOS PESSOAIS
                _secao('Dados Pessoais'),
                _campo(nome, 'Nome Completo'),
                _campo(email, 'Email', tipo: TextInputType.emailAddress),
                _campo(telefone, 'Telefone',
                    tipo: TextInputType.phone, mascara: _telefoneMask),
                _campo(cpf, 'CPF',
                    tipo: TextInputType.number, mascara: _cpfMask),

                // ENDEREÇO
                _secao('Endereço'),

                // CEP com botão de busca
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _campo(cep, 'CEP',
                          tipo: TextInputType.number,
                          mascara: _cepMask,
                          onChanged: (v) {
                            if (v.replaceAll(RegExp(r'[^0-9]'), '').length == 8) {
                              _buscarCep(v);
                            }
                          }),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: _carregandoCep
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.azulEscuro,
                                ),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: AppColors.azulEscuro,
                              ),
                              onPressed: () => _buscarCep(cep.text),
                              tooltip: 'Buscar CEP',
                            ),
                    ),
                  ],
                ),

                _campo(rua, 'Rua / Logradouro'),
                _campo(bairro, 'Bairro'),

                // Número e Complemento lado a lado
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _campo(numero, 'Número',
                          tipo: TextInputType.number),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: _campo(
                        complemento,
                        'Complemento',
                        obrigatorio: false,
                      ),
                    ),
                  ],
                ),

                // DROPDOWN DE ESTADO
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DropdownButtonFormField<String>(
                    value: _estadoSelecionado,
                    decoration: InputDecoration(
                      hintText: 'Estado',
                      filled: true,
                      fillColor: AppColors.cinzaCampo,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: _estados.map((e) {
                      return DropdownMenuItem<String>(
                        value: e['sigla'],
                        child: Text('${e['sigla']} — ${e['nome']}'),
                      );
                    }).toList(),
                    onChanged: (uf) {
                      if (uf != null) {
                        setState(() => _estadoSelecionado = uf);
                        _carregarMunicipios(uf);
                      }
                    },
                    validator: (v) =>
                        v == null ? 'Selecione o estado' : null,
                  ),
                ),

                // DROPDOWN DE MUNICÍPIO
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _carregandoMunicipios
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cinzaCampo,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.azulEscuro,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Carregando municípios...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : DropdownButtonFormField<String>(
                          value: _municipioSelecionado,
                          decoration: InputDecoration(
                            hintText: _estadoSelecionado == null
                                ? 'Selecione o estado primeiro'
                                : 'Município',
                            filled: true,
                            fillColor: AppColors.cinzaCampo,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: _municipios.map((m) {
                            return DropdownMenuItem<String>(
                              value: m,
                              child: Text(m),
                            );
                          }).toList(),
                          onChanged: _estadoSelecionado == null
                              ? null
                              : (m) => setState(
                                    () => _municipioSelecionado = m,
                                  ),
                          validator: (v) =>
                              v == null ? 'Selecione o município' : null,
                        ),
                ),

                // SENHA
                _secao('Senha'),
                _campo(senha, 'Senha', isSenha: true),
                _campo(confirmarSenha, 'Confirmar Senha', isSenha: true),

                const SizedBox(height: 20),

                // BOTÃO CADASTRAR
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.azulBotao,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                    ),
                    onPressed: _carregando ? null : _fazerCadastro,
                    child: _carregando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Cadastrar'),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Título de seção
  Widget _secao(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.azulEscuro,
        ),
      ),
    );
  }

  // Campo de texto reutilizável
  Widget _campo(
    TextEditingController controller,
    String hint, {
    bool isSenha = false,
    bool obrigatorio = true,
    TextInputType tipo = TextInputType.text,
    MaskTextInputFormatter? mascara,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isSenha,
        keyboardType: tipo,
        inputFormatters: mascara != null ? [mascara] : [],
        onChanged: onChanged,
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
            obrigatorio && value!.isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }
}
