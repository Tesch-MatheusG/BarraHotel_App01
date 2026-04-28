import 'package:atividadep1/app/models/quarto_model.dart';
import 'package:flutter/material.dart';
import '../reserva_page.dart';
import '../../views/cores.dart';

class DetalheQuartoPage extends StatefulWidget {
  final Quarto quarto;

  const DetalheQuartoPage({super.key, required this.quarto});

  @override
  State<DetalheQuartoPage> createState() => _DetalheQuartoPageState();
}

class _DetalheQuartoPageState extends State<DetalheQuartoPage> {
  final PageController _pageController = PageController();
  int _paginaAtual = 0;

  int get _total => widget.quarto.comodidades.length > 3 ? 3 : 2;

  static const List<Color> _cores = [
    Color(0xFF607D8B),
    Color(0xFF546E7A),
    Color(0xFF455A64),
  ];

  IconData _iconeComodidade(String comodidade) {
    final lower = comodidade.toLowerCase();
    if (lower.contains('tv')) return Icons.tv;
    if (lower.contains('ar')) return Icons.ac_unit;
    if (lower.contains('ventilador')) return Icons.air;
    if (lower.contains('frigobar')) return Icons.kitchen;
    if (lower.contains('banheira')) return Icons.bathtub;
    if (lower.contains('vista') || lower.contains('mar')) {
      return Icons.beach_access;
    }
    if (lower.contains('varanda')) return Icons.deck;
    return Icons.check_circle_outline;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quarto = widget.quarto;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.azulEscuro,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.azulEscuro,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _CarrosselGrande(
                total: _total,
                cores: _cores,
                pageController: _pageController,
                paginaAtual: _paginaAtual,
                onPageChanged: (p) => setState(() => _paginaAtual = p),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          quarto.nome,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'R\$ ${quarto.preco.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.azulEscuro,
                            ),
                          ),
                          const Text(
                            'por noite',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    children: [
                      _Chip(
                        icon: Icons.person_outline,
                        label:
                            '${quarto.numeroPessoas} Pessoa${quarto.numeroPessoas > 1 ? 's' : ''}',
                      ),
                      _Chip(
                        icon: Icons.bed_outlined,
                        label: quarto.tipoCama,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  const Text(
                    'Comodidades',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3.5,
                    children: quarto.comodidades.map((c) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.azulClaro,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.azulEscuro.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _iconeComodidade(c),
                              size: 18,
                              color: AppColors.azulEscuro,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                c,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  const Text(
                    'Incluído na estadia',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  const SizedBox(height: 12),

                  _ItemInclusoDetalhe(
                    icon: Icons.free_breakfast_outlined,
                    titulo: 'Café da Manhã Completo',
                    subtitulo: '08H - 10h',
                  ),
                  const SizedBox(height: 10),
                  _ItemInclusoDetalhe(
                    icon: Icons.directions_car_outlined,
                    titulo: 'Garagem Coberta',
                    subtitulo: 'Gratuito e Seguro',
                  ),
                  const SizedBox(height: 10),
                  _ItemInclusoDetalhe(
                    icon: Icons.wifi,
                    titulo: 'Internet',
                    subtitulo: 'Wi-fi gratuito',
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReservaPage(quarto: quarto),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.azulEscuro,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Reservar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarrosselGrande extends StatelessWidget {
  final int total;
  final List<Color> cores;
  final PageController pageController;
  final int paginaAtual;
  final ValueChanged<int> onPageChanged;

  const _CarrosselGrande({
    required this.total,
    required this.cores,
    required this.pageController,
    required this.paginaAtual,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: pageController,
          itemCount: total,
          onPageChanged: onPageChanged,
          itemBuilder: (_, index) {
            return Container(
              color: cores[index % cores.length],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Icon(
                    Icons.bed,
                    size: 80,
                    color: Colors.white.withOpacity(0.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Foto ${index + 1} de $total',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              total,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: paginaAtual == i ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: paginaAtual == i
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.cinzaTexto),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
          ),
        ],
      ),
    );
  }
}

class _ItemInclusoDetalhe extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;

  const _ItemInclusoDetalhe({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.azulClaro,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.azulEscuro),
        ),
        const SizedBox(width: 12),
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