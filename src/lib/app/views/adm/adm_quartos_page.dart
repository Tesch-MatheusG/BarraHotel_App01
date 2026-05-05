import 'package:flutter/material.dart';
import '../../data/quarto_mock_store.dart';
import '../../models/quarto_model.dart';
import '../cores.dart';

class AdmQuartosPage extends StatefulWidget {
  const AdmQuartosPage({super.key});

  @override
  State<AdmQuartosPage> createState() => _AdmQuartosPageState();
}

class _AdmQuartosPageState extends State<AdmQuartosPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categorias.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundoPagina,
      appBar: AppBar(
        backgroundColor: AppColors.azulEscuro,
        foregroundColor: Colors.white,
        title: const Text(
          'Gerenciar Quartos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          isScrollable: true,
          tabs: categorias.map((c) => Tab(text: c.label)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categorias
            .map((cat) => _ListaQuartosAdm(
                  categoria: cat,
                  onAtualizar: () => setState(() {}),
                ))
            .toList(),
      ),
    );
  }
}

class _ListaQuartosAdm extends StatelessWidget {
  final CategoriaQuarto categoria;
  final VoidCallback onAtualizar;

  const _ListaQuartosAdm({
    required this.categoria,
    required this.onAtualizar,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: categoria.quartos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _CardQuartoAdm(
          quarto: categoria.quartos[index],
          onAtualizar: onAtualizar,
        );
      },
    );
  }
}

class _CardQuartoAdm extends StatelessWidget {
  final Quarto quarto;
  final VoidCallback onAtualizar;

  const _CardQuartoAdm({
    required this.quarto,
    required this.onAtualizar,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // NOME + PREÇO
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  quarto.nome,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              Text(
                'R\$ ${quarto.preco.toStringAsFixed(0)}/noite',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.azulEscuro,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // TIPO DE CAMA + CAPACIDADE
          Row(
            children: [
              const Icon(
                Icons.bed_outlined,
                size: 14,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                quarto.tipoCama,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.person_outline,
                size: 14,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                '${quarto.numeroPessoas} pessoa${quarto.numeroPessoas > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // BOTÃO EDITAR DIÁRIA
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _editarDiaria(context),
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Editar valor da diária'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.azulEscuro,
                side: const BorderSide(color: AppColors.azulEscuro),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editarDiaria(BuildContext context) {
    final controller = TextEditingController(
      text: quarto.preco.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Editar diária — ${quarto.nome}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Novo valor (R\$)',
            prefixIcon: const Icon(
              Icons.attach_money,
              color: AppColors.azulEscuro,
            ),
            filled: true,
            fillColor: AppColors.fundoPagina,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cinzaBorda),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.azulEscuro,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final novoPreco = double.tryParse(controller.text);
              if (novoPreco != null && novoPreco > 0) {
                quarto.atualizarPreco(novoPreco);
                Navigator.pop(context);
                onAtualizar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Valor atualizado com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Informe um valor válido.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}