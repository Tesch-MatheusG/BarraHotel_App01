import 'package:flutter/material.dart';
import '../data/sessao.dart';
import 'cores.dart';
import 'perfil_page.dart';
import '../views/reservas/minhas_reservas_page.dart';

// Menu lateral (drawer) com dados do usuário logado e opções de navegação
class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = Sessao.usuarioLogado; // recupera o usuário da sessão ativa

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75, // ocupa 75% da largura da tela
      child: SafeArea(
        child: Column(
          children: [

            // CABEÇALHO com avatar, nome e e-mail do usuário logado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: AppColors.azulEscuro,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    usuario?.nome ?? 'Usuário', // fallback caso a sessão esteja vazia
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    usuario?.email ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Navega para a página de perfil do usuário
            _ItemMenu(
              icon: Icons.person_outline,
              label: 'Perfil',
              onTap: () {
                Navigator.pop(context); // fecha o drawer antes de navegar
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PerfilPage()),
                );
              },
            ),

            // Navega para a página de reservas do usuário
            _ItemMenu(
              icon: Icons.bookmark_outline,
              label: 'Minhas Reservas',
              onTap: () {
                Navigator.pop(context); // fecha o drawer antes de navegar
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MinhasReservasPage(),
                  ),
                );
              },
            ),

            const Divider(indent: 16, endIndent: 16),

            // Opção de logout em vermelho para destacar a ação destrutiva
            _ItemMenu(
              icon: Icons.logout,
              label: 'Sair da Conta',
              cor: AppColors.vermelho,
              onTap: () => _confirmarSaida(context),
            ),

            const Spacer(), // empurra a versão para o final do drawer

            // Versão do app no rodapé do drawer
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Barra Hotel App v1.0',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Diálogo de confirmação antes de encerrar a sessão
  void _confirmarSaida(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.vermelho,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Sessao.encerrar(); // limpa o usuário da sessão
              Navigator.pop(context); // fecha o diálogo
              Navigator.pushReplacementNamed(context, '/login'); // redireciona para o login
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

// Item reutilizável do menu lateral com ícone, label e cor opcional
class _ItemMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? cor; // cor personalizada — padrão azulEscuro, vermelho para logout

  const _ItemMenu({
    required this.icon,
    required this.label,
    required this.onTap,
    this.cor,
  });

  @override
  Widget build(BuildContext context) {
    final color = cor ?? AppColors.azulEscuro; // aplica cor customizada ou padrão

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}