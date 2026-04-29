import 'package:flutter/material.dart';
import '../../data/sessao.dart';
import '../../models/usuario_model.dart';
import '../cores.dart';
import 'adm_hospedes_page.dart';
import 'adm_reservas_page.dart';
import 'adm_quartos_page.dart';
import 'adm_funcionarios_page.dart';

class AdmHomePage extends StatelessWidget {
  const AdmHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = Sessao.usuarioLogado;
    final isMaster = usuario?.perfil == PerfilUsuario.master;

    return Scaffold(
      backgroundColor: AppColors.fundoPagina,
      appBar: AppBar(
        backgroundColor: AppColors.azulEscuro,
        foregroundColor: Colors.white,
        title: const Text(
          'Painel Administrativo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmarSaida(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // CABEÇALHO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.azulEscuro,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuario?.nome ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isMaster ? 'Master' : 'Administrador',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Menu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),

            const SizedBox(height: 12),

            // CARDS DE MENU
            _CardMenu(
              icon: Icons.people_outline,
              titulo: 'Hóspedes',
              descricao: 'Visualizar todos os hóspedes cadastrados',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdmHospedesPage()),
              ),
            ),

            _CardMenu(
              icon: Icons.bookmark_outline,
              titulo: 'Reservas',
              descricao: 'Gerenciar reservas, check-in, check-out e pagamentos',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdmReservasPage()),
              ),
            ),

            _CardMenu(
              icon: Icons.bed_outlined,
              titulo: 'Quartos',
              descricao: 'Gerenciar quartos e valores de diárias',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdmQuartosPage()),
              ),
            ),

            if (isMaster)
              _CardMenu(
                icon: Icons.manage_accounts_outlined,
                titulo: 'Funcionários',
                descricao: 'Gerenciar acessos e promover usuários a ADM',
                cor: AppColors.azulMedio,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdmFuncionariosPage(),
                  ),
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

class _CardMenu extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String descricao;
  final VoidCallback onTap;
  final Color? cor;

  const _CardMenu({
    required this.icon,
    required this.titulo,
    required this.descricao,
    required this.onTap,
    this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cinzaBorda),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (cor ?? AppColors.azulEscuro).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: cor ?? AppColors.azulEscuro,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: cor ?? AppColors.azulEscuro,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descricao,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: cor ?? AppColors.azulEscuro,
            ),
          ],
        ),
      ),
    );
  }
}