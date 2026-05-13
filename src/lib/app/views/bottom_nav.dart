import 'package:flutter/material.dart';
import 'quarto/quartos_page.dart';
import 'cores.dart';
import 'chatbot_page.dart';

// Barra de navegação inferior compartilhada entre as páginas principais
class BottomNav extends StatelessWidget {
  final int currentIndex; // índice da aba atualmente ativa

  const BottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: AppColors.azulMedio,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      elevation: 8,
      onTap: (index) {
        // Só navega se a aba tocada for diferente da atual (evita reconstrução desnecessária)
        if (index == 0 && currentIndex != 0) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        if (index == 1 && currentIndex != 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const QuartosPage()),
          );
        }
        if (index == 2 && currentIndex != 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ChatbotPage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home), // ícone preenchido quando ativo
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