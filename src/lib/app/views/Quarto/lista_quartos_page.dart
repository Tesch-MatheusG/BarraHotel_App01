import 'package:atividadep1/app/models/quarto_model.dart';
import 'package:flutter/material.dart';
import 'detalhequarto_page.dart';
import '../../views/cores.dart';

// Página que exibe a lista de quartos de uma categoria específica
class ListaQuartosPage extends StatelessWidget {
  final CategoriaQuarto categoria; // categoria recebida da tela anterior

  const ListaQuartosPage({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: categoria.quartos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _CardQuarto(quarto: categoria.quartos[index]);
      },
    );
  }
}

// Card individual de cada quarto com carrossel, informações e botão de reserva
class _CardQuarto extends StatelessWidget {
  final Quarto quarto;

  const _CardQuarto({required this.quarto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _abrirDetalhes(context), // toque em qualquer área do card abre os detalhes
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cinzaBorda),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias, // garante que o carrossel respeite o borderRadius
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carrossel de imagens no topo do card
            _CarrosselImagens(quarto: quarto),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome do quarto
                  Text(
                    quarto.nome,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Capacidade de pessoas com pluralização dinâmica
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Color(0xFF888888),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${quarto.numeroPessoas} Pessoa${quarto.numeroPessoas > 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Badge com o tipo de cama
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      quarto.tipoCama,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Comodidades',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Lista de comodidades em formato wrap com ícone de check
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: quarto.comodidades
                        .map(
                          (c) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check,
                                size: 14,
                                color: AppColors.azulEscuro,
                              ),
                              const SizedBox(width: 4),
                              Text(c, style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 14),

                  // Botão de reserva — navega para os detalhes do quarto
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _abrirDetalhes(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.azulEscuro,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Reservar',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navega para a página de detalhes do quarto selecionado
  void _abrirDetalhes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalheQuartoPage(quarto: quarto),
      ),
    );
  }
}

// Carrossel de imagens placeholder do quarto com indicadores e botões de navegação
class _CarrosselImagens extends StatefulWidget {
  final Quarto quarto;

  const _CarrosselImagens({required this.quarto});

  @override
  State<_CarrosselImagens> createState() => _CarrosselImagensState();
}

class _CarrosselImagensState extends State<_CarrosselImagens> {
  final PageController _pageController = PageController();
  int _paginaAtual = 0; // índice do slide visível

  // Quartos quádruplos exibem 3 slides, os demais exibem 2
  int get _total => widget.quarto.numeroPessoas == 4 ? 3 : 2;

  // Tons de azul acinzentado para os slides placeholder
  static const List<Color> _cores = [
    Color(0xFF90A4AE),
    Color(0xFF78909C),
    Color(0xFF607D8B),
  ];

  @override
  void dispose() {
    _pageController.dispose(); // libera o controller ao desmontar o widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Slides do carrossel com placeholder de imagem
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _total,
            onPageChanged: (p) => setState(() => _paginaAtual = p), // atualiza indicadores
            itemBuilder: (context, index) {
              return Container(
                color: _cores[index % _cores.length], // cicla pelas cores disponíveis
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bed,
                      size: 60,
                      color: Colors.white.withOpacity(0.5), // ícone semitransparente
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${index + 1} / $_total', // contador de slides
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Indicadores de página na parte inferior do carrossel
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _total,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250), // animação suave
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _paginaAtual == i ? 18 : 6, // indicador ativo é mais largo
                height: 6,
                decoration: BoxDecoration(
                  color: _paginaAtual == i
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),

        // Seta esquerda — visível apenas quando não estiver no primeiro slide
        if (_paginaAtual > 0)
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: _BotaoSeta(
                icon: Icons.chevron_left,
                onTap: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
          ),

        // Seta direita — visível apenas quando não estiver no último slide
        if (_paginaAtual < _total - 1)
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: _BotaoSeta(
                icon: Icons.chevron_right,
                onTap: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Botão circular semitransparente usado nas setas de navegação do carrossel
class _BotaoSeta extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _BotaoSeta({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3), // fundo escuro semitransparente
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}