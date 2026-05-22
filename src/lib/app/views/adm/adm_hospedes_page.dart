import 'package:flutter/material.dart';
import '../../data/usuario_mock_store.dart';
import '../../models/usuario_model.dart';
import '../cores.dart';

// Página de listagem de hóspedes para o painel administrativo
class AdmHospedesPage extends StatefulWidget {
  const AdmHospedesPage({super.key});

  @override
  State<AdmHospedesPage> createState() => _AdmHospedesPageState();
}

class _AdmHospedesPageState extends State<AdmHospedesPage> {
  final TextEditingController _buscaController = TextEditingController(); // controlador do campo de busca
  String _busca = ''; // texto digitado na busca

  @override
  void dispose() {
    _buscaController.dispose(); // libera o controller ao sair da página
    super.dispose();
  }

  // Retorna apenas clientes filtrados por nome, e-mail ou CPF
  List<UsuarioModel> get _hospedadesFiltrados {
    final clientes = UsuarioMockStore.clientes;
    if (_busca.isEmpty) return clientes; // sem filtro, retorna todos os clientes
    return clientes
        .where((u) =>
            u.nome.toLowerCase().contains(_busca.toLowerCase()) ||
            u.email.toLowerCase().contains(_busca.toLowerCase()) ||
            u.cpf.contains(_busca)) // permite buscar pelo CPF sem formatação
        .toList();
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
      ),
      body: Column(
        children: [

          // BARRA DE BUSCA
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _buscaController,
              onChanged: (v) => setState(() => _busca = v), // atualiza o filtro a cada caractere digitado
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

          // CONTADOR de resultados com pluralização dinâmica
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  '${_hospedadesFiltrados.length} hóspede${_hospedadesFiltrados.length != 1 ? 's' : ''} encontrado${_hospedadesFiltrados.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // LISTA de hóspedes filtrados
          Expanded(
            child: _hospedadesFiltrados.isEmpty
                // estado vazio — nenhum hóspede encontrado
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum hóspede encontrado.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                // lista com card de cada hóspede
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _hospedadesFiltrados.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _CardHospede(
                        hospede: _hospedadesFiltrados[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Card individual de cada hóspede na listagem
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
          // Avatar padrão para todos os hóspedes
          const CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.azulClaro,
            child: Icon(
              Icons.person,
              color: AppColors.azulEscuro,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          // Dados resumidos: nome, e-mail e CPF
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
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                // CPF com ícone de identificação
                Row(
                  children: [
                    const Icon(
                      Icons.badge_outlined,
                      size: 13,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      hospede.cpf,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Botão para abrir o modal com todos os dados do hóspede
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: AppColors.azulEscuro,
            ),
            onPressed: () => _verDetalhes(context),
          ),
        ],
      ),
    );
  }

  // Abre um bottom sheet com os dados completos do hóspede
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
            // Indicador visual de arraste do bottom sheet
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
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Campos detalhados do hóspede
            _ItemDetalhe(Icons.person_outline, 'Nome', hospede.nome),
            _ItemDetalhe(Icons.email_outlined, 'E-mail', hospede.email),
            _ItemDetalhe(Icons.phone_outlined, 'Telefone', hospede.telefone),
            _ItemDetalhe(Icons.badge_outlined, 'CPF', hospede.cpf),
            _ItemDetalhe(Icons.location_on_outlined, 'CEP', hospede.cep),
            _ItemDetalhe(Icons.home_outlined, 'Rua', hospede.rua,),
            _ItemDetalhe(Icons.home_outlined, 'Número', hospede.numero,),
            _ItemDetalhe(Icons.home_outlined, 'Complemento', hospede.complemento,),
            _ItemDetalhe(Icons.home_outlined, 'Bairro', hospede.bairro,),
            _ItemDetalhe(Icons.home_outlined, 'Município', hospede.municipio,),
            _ItemDetalhe(Icons.home_outlined, 'Estado', hospede.estado,),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Widget reutilizável para exibir um campo com ícone, label e valor no modal de detalhes
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
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              valor.isEmpty ? '—' : valor, // exibe traço se o campo estiver vazio
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