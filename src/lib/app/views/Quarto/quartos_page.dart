import 'package:atividadep1/app/models/quarto_model.dart';
import 'package:atividadep1/app/viewmodels/quarto_viewmodel.dart';
import 'package:flutter/material.dart';
import 'lista_quartos_page.dart';
import '../bottom_nav.dart';
import '../../views/cores.dart';
import '../drawer_menu.dart';

// Página principal de quartos — exibe benefícios inclusos e abas por categoria
class QuartosPage extends StatefulWidget {
  const QuartosPage({super.key});

  @override
  State<QuartosPage> createState() => _QuartosPageState();
}

class _QuartosPageState extends State<QuartosPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // controla a navegação entre as categorias

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categorias.length, vsync: this); // uma aba por categoria
  }

  @override
  void dispose() {
    _tabController.dispose(); // libera o controller ao sair da página
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundoPagina,
      drawer: const DrawerMenu(), // menu lateral
      appBar: AppBar(
        backgroundColor: AppColors.azulEscuro,
        foregroundColor: Colors.white,
        title: const Text(
          'Nossos Quartos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      bottomNavigationBar: BottomNav(currentIndex: 1), // aba "Quartos" ativa
      body: SafeArea(
        child: NestedScrollView(
          // Cabeçalho com o card de benefícios inclusos — rola junto com o conteúdo
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(child: _CardIncluido()),
          ],
          body: Column(
            children: [
              _TabsCategoria(tabController: _tabController), // abas de categoria estilo pill
              const SizedBox(height: 4),
              // Conteúdo de cada aba corresponde à lista de quartos da categoria
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

// Card fixo exibindo os benefícios inclusos em todos os quartos
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
          // Itens de benefício fixos para todos os quartos
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

// Widget reutilizável para cada item de benefício com ícone, título e subtítulo
class _ItemIncluido extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo; // informação complementar (ex: horário, descrição)

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

// Abas de categoria no estilo "pill" — destaca a aba ativa com fundo azul
class _TabsCategoria extends StatelessWidget {
  final TabController tabController;

  const _TabsCategoria({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE), // fundo cinza claro como trilho das abas
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        controller: tabController,
        // Indicador no estilo "pill" preenchendo toda a aba ativa
        indicator: BoxDecoration(
          color: AppColors.azulEscuro,
          borderRadius: BorderRadius.circular(30),
        ),
        indicatorSize: TabBarIndicatorSize.tab, // indicador ocupa toda a largura da aba
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        dividerColor: Colors.transparent, // remove a linha divisória padrão do TabBar
        tabs: categorias.map((c) => Tab(text: c.label)).toList(),
      ),
    );
  }
}