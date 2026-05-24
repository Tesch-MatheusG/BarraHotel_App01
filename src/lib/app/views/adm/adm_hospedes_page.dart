import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/usuario_model.dart';
import '../cores.dart';

class AdmHospedesPage extends StatefulWidget {
  const AdmHospedesPage({super.key});

  @override
  State<AdmHospedesPage> createState() => _AdmHospedesPageState();
}

class _AdmHospedesPageState extends State<AdmHospedesPage> {
  final TextEditingController _buscaController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  String _busca = '';
  List<UsuarioModel> _hospedes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarHospedes();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarHospedes() async {
    setState(() => _carregando = true);
    try {
      final snapshot = await _firestore
          .collection('usuarios')
          .where('perfil', isEqualTo: 'cliente')
          .get();

      setState(() {
        _hospedes = snapshot.docs.map((doc) {
          final data = doc.data();
          return UsuarioModel(
            nome: data['nome'] ?? '',
            email: data['email'] ?? '',
            senha: '',
            cpf: data['cpf'] ?? '',
            telefone: data['telefone'] ?? '',
            cep: data['cep'] ?? '',
            rua: data['rua'] ?? '',
            bairro: data['bairro'] ?? '',
            numero: data['numero'] ?? '',
            complemento: data['complemento'] ?? '',
            estado: data['estado'] ?? '',
            municipio: data['municipio'] ?? '',
          );
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar hóspedes.')),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  List<UsuarioModel> get _hospedesFiltrados {
    if (_busca.isEmpty) return _hospedes;
    return _hospedes.where((u) =>
        u.nome.toLowerCase().contains(_busca.toLowerCase()) ||
        u.email.toLowerCase().contains(_busca.toLowerCase()) ||
        u.cpf.contains(_busca)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundoPagina,
      appBar: AppBar(
        backgroundColor: AppColors.azulEscuro,
        foregroundColor: Colors.white,
        title: const Text(
          'Hóspedes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarHospedes,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: Column(
        children: [

          // BARRA DE BUSCA
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _buscaController,
              onChanged: (v) => setState(() => _busca = v),
              decoration: InputDecoration(
                hintText: 'Buscar por nome, e-mail ou CPF...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.azulEscuro,
                ),
                filled: true,
                fillColor: AppColors.fundoPagina,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // CONTADOR
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  '${_hospedesFiltrados.length} hóspede${_hospedesFiltrados.length != 1 ? 's' : ''} encontrado${_hospedesFiltrados.length != 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),

          // LISTA
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _hospedesFiltrados.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Nenhum hóspede encontrado.',
                              style: TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _hospedesFiltrados.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _CardHospede(
                            hospede: _hospedesFiltrados[index],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _CardHospede extends StatelessWidget {
  final UsuarioModel hospede;

  const _CardHospede({required this.hospede});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cinzaBorda),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.azulClaro,
            child: Icon(Icons.person, color: AppColors.azulEscuro, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hospede.nome,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hospede.email,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.badge_outlined, size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      hospede.cpf,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.azulEscuro),
            onPressed: () => _verDetalhes(context),
          ),
        ],
      ),
    );
  }

  void _verDetalhes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Dados do Hóspede',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _ItemDetalhe(Icons.person_outline, 'Nome', hospede.nome),
            _ItemDetalhe(Icons.email_outlined, 'E-mail', hospede.email),
            _ItemDetalhe(Icons.phone_outlined, 'Telefone', hospede.telefone),
            _ItemDetalhe(Icons.badge_outlined, 'CPF', hospede.cpf),
            _ItemDetalhe(Icons.location_on_outlined, 'CEP', hospede.cep),
            _ItemDetalhe(Icons.home_outlined, 'Rua', hospede.rua),
            _ItemDetalhe(Icons.tag, 'Número', hospede.numero),
            _ItemDetalhe(Icons.info_outline, 'Complemento', hospede.complemento),
            _ItemDetalhe(Icons.map_outlined, 'Bairro', hospede.bairro),
            _ItemDetalhe(Icons.location_city, 'Município', hospede.municipio),
            _ItemDetalhe(Icons.flag_outlined, 'Estado', hospede.estado),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ItemDetalhe extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;

  const _ItemDetalhe(this.icon, this.label, this.valor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.azulEscuro),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          Expanded(
            child: Text(
              valor.isEmpty ? '—' : valor,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}