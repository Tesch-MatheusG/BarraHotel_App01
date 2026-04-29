import 'package:flutter/material.dart';
import 'quarto/quartos_page.dart';
import 'cores.dart';
import 'chatbot_page.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

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