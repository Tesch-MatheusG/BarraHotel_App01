import 'package:flutter/material.dart';
import 'quarto/quartos_page.dart';
import '../viewmodels/quarto_viewmodel.dart';
import '../views/bottom_nav.dart';
import 'cores.dart';
import 'drawer_menu.dart';

// Página inicial do app, exibida após o login
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cor de fundo da página
      backgroundColor: AppColors.fundoPagina,
      // Menu lateral (gaveta)
      drawer: const DrawerMenu(),
      appBar: AppBar(
        // Cor de fundo da barra superior
        backgroundColor: AppColors.azulEscuro,
        // Cor dos ícones e texto da AppBar
        foregroundColor: Colors.white,
        title: const Text(
          'Barra Hotel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      // Barra de navegação inferior, com índice 0 (aba Home ativa)
      bottomNavigationBar: BottomNav(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          // Espaçamento interno horizontal e vertical do conteúdo
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seção com informações gerais sobre o hotel
              _SectionSobreHotel(),
              const SizedBox(height: 28),
              // Seção com cards de motivos para escolher o hotel
              _SectionPorQueEscolher(),
              const SizedBox(height: 28),
              // Seção com lista de diferenciais do hotel
              _SectionDiferenciais(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget privado que exibe o texto descritivo do hotel
class _SectionSobreHotel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título da seção
        const Text(
          'Sobre o Hotel',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 10),
        // Container com borda e fundo branco para o texto descritivo
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            // Borda cinza ao redor do container
            border: Border.all(color: AppColors.cinzaBorda),
          ),
          child: const Text(
            'O Barra Hotel oferece 12 tipos diferentes de acomodações, desde apartamentos simples, até executivos e master, atendendo hóspedes individuais, casais, grupos e famílias de até 4 pessoas.\n\n'
            'Todos os apartamentos contam com banheiro privativo, ducha elétrica, camas box e TV Smart.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF444444),
              // Altura de linha para melhor legibilidade
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget privado que exibe os cards "Por que escolher o Barra Hotel"
class _SectionPorQueEscolher extends StatelessWidget {
  // Lista de dados para cada card da seção
  final List<_CardInfo> cards = const [
    _CardInfo(
      icon: Icons.business_center_outlined,
      titulo: 'Viagem de Negócios',
      descricao:
          'Apartamentos executivos com mesa de trabalho e Wi-Fi gratuito, ideais para profissionais em viagem corporativa.',
      cor: Color(0xFFEAF0FB),
      iconeCor: Color(0xFF3A6BC4),
    ),
    _CardInfo(
      icon: Icons.celebration_outlined,
      titulo: 'Eventos e Celebrações',
      descricao:
          'Hospede-se conosco para participar de festas, formaturas, casamentos e eventos na região com conforto e praticidade.',
      cor: Color(0xFFF3EAFB),
      iconeCor: Color(0xFF8A3AC4),
    ),
    _CardInfo(
      icon: Icons.favorite_border,
      titulo: 'Férias e Lazer',
      descricao:
          'Familiares espaçosos, crianças até 5 anos não pagam. Perfeito para suas férias e momentos de descanso.',
      cor: Color(0xFFEAFBF0),
      iconeCor: Color(0xFF3AC47A),
    ),
    _CardInfo(
      icon: Icons.calendar_month_outlined,
      titulo: 'Estadias Prolongadas',
      descricao:
          'Ótima opção para quem precisa ficar temporariamente na cidade, seja a trabalho, estudo ou tratamento médico.',
      cor: Color(0xFFFBF3EA),
      iconeCor: Color(0xFFC47A3A),
    ),
    _CardInfo(
      icon: Icons.groups_outlined,
      titulo: 'Viagens em Grupo',
      descricao:
          'Ideal para excursões, grupos de amigos e famílias. Diversos quartos para diferentes tamanhos de grupos.',
      cor: Color(0xFFEAF7FB),
      iconeCor: Color(0xFF3AAFC4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título da seção
        const Text(
          'Por que Escolher o Barra Hotel?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 12),
        // Itera sobre a lista de cards e renderiza cada um com espaçamento
        ...cards.map((card) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CardPorque(info: card),
            )),
      ],
    );
  }
}

// Modelo de dados para cada card da seção "Por que escolher"
class _CardInfo {
  final IconData icon;
  final String titulo;
  final String descricao;
  // Cor de fundo do card
  final Color cor;
  // Cor do ícone e do título
  final Color iconeCor;

  const _CardInfo({
    required this.icon,
    required this.titulo,
    required this.descricao,
    required this.cor,
    required this.iconeCor,
  });
}

// Widget que renderiza visualmente um card individual
class _CardPorque extends StatelessWidget {
  final _CardInfo info;
  const _CardPorque({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Cor de fundo vinda do modelo de dados
        color: info.cor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container circular com ícone da categoria
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              // Fundo do ícone com opacidade reduzida
              color: info.iconeCor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(info.icon, color: info.iconeCor, size: 28),
          ),
          const SizedBox(width: 14),
          // Coluna com título e descrição do card
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título do card com a cor do ícone
                Text(
                  info.titulo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: info.iconeCor,
                  ),
                ),
                const SizedBox(height: 6),
                // Texto descritivo do card
                Text(
                  info.descricao,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF555555),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget privado que exibe a lista de diferenciais do hotel
class _SectionDiferenciais extends StatelessWidget {
  // Lista de diferenciais exibidos com ícone de check
  final List<String> itens = const [
    'Café da manhã completo incluído',
    'Estacionamento gratuito e seguro',
    'Wi-Fi gratuito em todos os apartamentos',
    'Todos com banheiro privativo e TV Smart',
    'Crianças de 0 a 5 anos não pagam',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Fundo azul médio para destacar a seção
        color: AppColors.azulMedio,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da seção em branco
          const Text(
            'Diferenciais',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          // Itera sobre os itens e renderiza cada um com ícone de check
          ...itens.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ícone de check azul claro
                  const Icon(Icons.check_circle,
                      color: Color(0xFF5DADE2), size: 18),
                  const SizedBox(width: 10),
                  // Texto do diferencial
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFDDEAF5),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}