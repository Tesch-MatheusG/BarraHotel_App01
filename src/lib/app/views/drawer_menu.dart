import 'package:flutter/material.dart';
import '../data/sessao.dart';
import 'cores.dart';
import 'perfil_page.dart';
import '../views/reservas/minhas_reservas_page.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = Sessao.usuarioLogado;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: SafeArea(
        child: Column(
          children: [

            // CABEÇALHO
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
                    usuario?.nome ?? 'Usuário',
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


            // OPÇÕES DO MENU
            // ACESSAR PÁGINA DO PERFIL
            _ItemMenu(
              icon: Icons.person_outline,
              label: 'Perfil',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PerfilPage()),
                );
              },
            ),

            //MINHAS RESERVAS
            _ItemMenu(
              icon: Icons.bookmark_outline,
              label: 'Minhas Reservas',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MinhasReservasPage(),
                  ),
                );
              },
            ),

            const Divider(indent: 16, endIndent: 16),


            // SAIR DA CONTA
             _ItemMenu(
              icon: Icons.logout,
              label: 'Sair da Conta',
              cor: AppColors.vermelho,
              onTap: () => _confirmarSaida(context),
            ),

            const Spacer(),

            // VERSÃO DO APP
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
              Sessao.encerrar();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

class _ItemMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? cor;

  const _ItemMenu({
    required this.icon,
    required this.label,
    required this.onTap,
    this.cor,
  });

 @override
  Widget build(BuildContext context) {
    final color = cor ?? AppColors.azulEscuro;

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