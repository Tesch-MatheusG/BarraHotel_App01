import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../data/sessao.dart';
import '../models/usuario_model.dart';
import 'cores.dart';
import '../data/usuario_mock_store.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _formKey = GlobalKey<FormState>();

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

  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );
  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp(r'[0-9]')},
  );

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

  @override
  void initState() {
    super.initState();
    final usuario = Sessao.usuarioLogado;
    _nome = TextEditingController(text: usuario?.nome ?? '');
    _telefone = TextEditingController(text: usuario?.telefone ?? '');
    _cep = TextEditingController(text: usuario?.cep ?? '');
    _rua = TextEditingController(text: usuario?.rua ?? '');
    _bairro = TextEditingController(text: usuario?.bairro ?? '');
    _numero = TextEditingController(text: usuario?.numero ?? '');
    _complemento = TextEditingController(text: usuario?.complemento ?? '');
    _estadoSelecionado =
        usuario?.estado.isEmpty == true ? null : usuario?.estado;
    _municipioSelecionado =
        usuario?.municipio.isEmpty == true ? null : usuario?.municipio;

    if (_estadoSelecionado != null) {
      _carregarMunicipios(_estadoSelecionado!);
    }
  }

  @override
  void dispose() {
    _nome.dispose();
    _telefone.dispose();
    _cep.dispose();
    _rua.dispose();
    _bairro.dispose();
    _numero.dispose();
    _complemento.dispose();
    super.dispose();
  }

  Future<void> _carregarMunicipios(String uf) async {
    setState(() {
      _carregandoMunicipios = true;
      _municipios = [];
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

  Future<void> _buscarCep(String cepDigitado) async {
    final cepLimpo = cepDigitado.replaceAll(RegExp(r'[^0-9]'), '');
    if (cepLimpo.length != 8) return;

    setState(() => _carregandoCep = true);

    try {
      final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cepLimpo/json/'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['erro'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('CEP não encontrado.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        _rua.text = data['logradouro'] ?? '';
        _bairro.text = data['bairro'] ?? '';

        final uf = data['uf'] ?? '';
        setState(() {
          _estadoSelecionado = uf;
          _municipioSelecionado = null;
        });

        await _carregarMunicipios(uf);
        final cidade = data['localidade'] ?? '';
        setState(() => _municipioSelecionado = cidade);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Endereço preenchido automaticamente!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao buscar CEP.')),
      );
    } finally {
      setState(() => _carregandoCep = false);
    }
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final atual = Sessao.usuarioLogado!;
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
      Sessao.iniciar(atualizado);
      UsuarioMockStore.atualizar(atualizado);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
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
              const Text(
                'E-mail e CPF não podem ser alterados.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // DADOS PESSOAIS
              _secao('Dados Pessoais'),
              _campo(controller: _nome, label: 'Nome Completo', icon: Icons.person_outline),
              _campo(controller: _telefone, label: 'Telefone', icon: Icons.phone_outlined, tipo: TextInputType.phone, mascara: _telefoneMask),

              // ENDEREÇO
              _secao('Endereço'),

              // CEP com busca automática
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _campo(
                      controller: _cep,
                      label: 'CEP',
                      icon: Icons.location_on_outlined,
                      tipo: TextInputType.number,
                      mascara: _cepMask,
                      onChanged: (v) {
                        if (v.replaceAll(RegExp(r'[^0-9]'), '').length == 8) {
                          _buscarCep(v);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  _carregandoCep
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
                          icon: const Icon(Icons.search, color: AppColors.azulEscuro),
                          onPressed: () => _buscarCep(_cep.text),
                          tooltip: 'Buscar CEP',
                        ),
                ],
              ),

              _campo(controller: _rua, label: 'Rua / Logradouro', icon: Icons.home_outlined),
              _campo(controller: _bairro, label: 'Bairro', icon: Icons.map_outlined),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _campo(controller: _numero, label: 'Número', icon: Icons.tag, tipo: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: _campo(controller: _complemento, label: 'Complemento', icon: Icons.info_outline, obrigatorio: false),
                  ),
                ],
              ),

              // DROPDOWN ESTADO
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DropdownButtonFormField<String>(
                  value: _estadoSelecionado,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    prefixIcon: const Icon(Icons.flag_outlined, color: AppColors.azulEscuro, size: 20),
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
                  ),
                  items: _estados.map((e) {
                    return DropdownMenuItem<String>(
                      value: e['sigla'],
                      child: Text('${e['sigla']} — ${e['nome']}'),
                    );
                  }).toList(),
                  onChanged: (uf) {
                    if (uf != null) {
                      setState(() {
                        _estadoSelecionado = uf;
                        _municipioSelecionado = null;
                      });
                      _carregarMunicipios(uf);
                    }
                  },
                  validator: (v) => v == null ? 'Selecione o estado' : null,
                ),
              ),

              // DROPDOWN MUNICÍPIO
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _carregandoMunicipios
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cinzaBorda),
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
                            Text('Carregando municípios...', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : DropdownButtonFormField<String>(
                        value: _municipioSelecionado,
                        decoration: InputDecoration(
                          labelText: _estadoSelecionado == null
                              ? 'Selecione o estado primeiro'
                              : 'Município',
                          prefixIcon: const Icon(Icons.location_city, color: AppColors.azulEscuro, size: 20),
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
                        ),
                        items: _municipios.map((m) {
                          return DropdownMenuItem<String>(
                            value: m,
                            child: Text(m),
                          );
                        }).toList(),
                        onChanged: _estadoSelecionado == null
                            ? null
                            : (m) => setState(() => _municipioSelecionado = m),
                        validator: (v) => v == null ? 'Selecione o município' : null,
                      ),
              ),

              // BOTÃO SALVAR
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _campo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obrigatorio = true,
    bool isSenha = false,
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
            borderSide: const BorderSide(color: AppColors.azulEscuro, width: 1.5),
          ),
        ),
        validator: (value) =>
            obrigatorio && value!.isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }
}