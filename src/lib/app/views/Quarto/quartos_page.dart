import 'package:atividadep1/app/models/quarto_model.dart';
import 'package:atividadep1/app/viewmodels/quarto_viewmodel.dart';
import 'package:flutter/material.dart';
import 'lista_quartos_page.dart';
import '../bottom_nav.dart';
import '../../views/cores.dart';
import '../drawer_menu.dart';

// PÁGINA PRINCIPAL DE QUARTOS
// Exibe os benefícios inclusos e as abas de categoria (Single, Casal, Triplo, Quádruplo)
class QuartosPage extends StatefulWidget {
  const QuartosPage({super.key});

  @override
  State<QuartosPage> createState() => _QuartosPageState();
}

class _QuartosPageState extends State<QuartosPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Uma aba por categoria de quarto
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
      drawer: const DrawerMenu(),
      appBar: AppBar(
        backgroundColor: AppColors.azulEscuro,
        foregroundColor: Colors.white,
        title: const Text(
          'Nossos Quartos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      bottomNavigationBar: BottomNav(currentIndex: 1),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(child: _CardIncluido()),
          ],
          body: Column(
            children: [
              _TabsCategoria(tabController: _tabController),
              const SizedBox(height: 4),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: categorias
                      .map((cat) => ListaQuartosPage(categoria: cat))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _CardIncluido extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cinzaBorda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Incluído em todos os quartos:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF0D2A7A),
            ),
          ),
          const SizedBox(height: 12),
          _ItemIncluido(
            icon: Icons.free_breakfast_outlined,
            titulo: 'Café da Manhã Completo',
            subtitulo: '08H - 10h',
          ),
          const SizedBox(height: 10),
          _ItemIncluido(
            icon: Icons.directions_car_outlined,
            titulo: 'Garagem Coberta',
            subtitulo: 'Gratuito e Seguro',
          ),
          const SizedBox(height: 10),
          _ItemIncluido(
            icon: Icons.wifi,
            titulo: 'Internet',
            subtitulo: 'Wi-fi gratuito',
          ),
        ],
      ),
    );
  }
}

// Item de benefício com ícone, título e subtítulo
class _ItemIncluido extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;

  const _ItemIncluido({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.azulEscuro),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitulo,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF777777),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _TabsCategoria extends StatelessWidget {
  final TabController tabController;

  const _TabsCategoria({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        controller: tabController,
        // Indicador no estilo "pill" preenchendo toda a aba
        indicator: BoxDecoration(
          color: AppColors.azulEscuro,
          borderRadius: BorderRadius.circular(30),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        dividerColor: Colors.transparent,
        tabs: categorias.map((c) => Tab(text: c.label)).toList(),
      ),
    );
  }
}