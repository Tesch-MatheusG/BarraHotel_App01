import 'package:flutter/material.dart';
import '../views/Quarto/quartos_page.dart';
import '../viewmodels/quarto_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar: _BottomNav(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionSobreHotel(),
              const SizedBox(height: 28),
              _SectionPorQueEscolher(),
              const SizedBox(height: 28),
              _SectionDiferenciais(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionSobreHotel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sobre o Hotel',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDDDDDD)),
          ),
          child: const Text(
            'O Barra Hotel oferece 12 tipos diferentes de acomodações, desde apartamentos simples, até executivos e master, atendendo hóspedes individuais, casais, grupos e famílias de até 4 pessoas.\n\n'
            'Todos os apartamentos contam com banheiro privativo, ducha elétrica, camas box e TV Smart.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF444444),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionPorQueEscolher extends StatelessWidget {
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
        const Text(
          'Por que Escolher o Barra Hotel?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 12),
        ...cards.map((card) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CardPorque(info: card),
            )),
      ],
    );
  }
}

class _CardInfo {
  final IconData icon;
  final String titulo;
  final String descricao;
  final Color cor;      
  final Color iconeCor; 

  const _CardInfo({
    required this.icon,
    required this.titulo,
    required this.descricao,
    required this.cor,
    required this.iconeCor,
  });
}

class _CardPorque extends StatelessWidget {
  final _CardInfo info;
  const _CardPorque({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: info.cor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: info.iconeCor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(info.icon, color: info.iconeCor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.titulo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: info.iconeCor,
                  ),
                ),
                const SizedBox(height: 6),
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

class _SectionDiferenciais extends StatelessWidget {
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
        color: const Color(0xFF1A2E5A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Diferenciais',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          ...itens.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle,
                      color: Color(0xFF5DADE2), size: 18),
                  const SizedBox(width: 10),
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

class _BottomNav extends StatelessWidget {
  final int currentIndex;

  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF1A2E5A),
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      elevation: 8,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QuartosPage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bed_outlined),
          activeIcon: Icon(Icons.bed),
          label: 'Quartos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy_outlined),
          activeIcon: Icon(Icons.smart_toy),
          label: 'Assistente',
        ),
      ],
    );
  }
}