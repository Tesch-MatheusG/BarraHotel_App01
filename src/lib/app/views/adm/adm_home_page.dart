import 'package:flutter/material.dart';
import '../../data/sessao.dart';
import '../../models/usuario_model.dart';
import '../cores.dart';
import 'adm_hospedes_page.dart';
import 'adm_reservas_page.dart';
import 'adm_quartos_page.dart';
import 'adm_funcionarios_page.dart';

// Página inicial do painel administrativo
class AdmHomePage extends StatelessWidget {
  const AdmHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = Sessao.usuarioLogado; // recupera o usuário da sessão ativa
    final isMaster = usuario?.perfil == PerfilUsuario.master; // verifica se é perfil master

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
          // Botão de logout no canto superior direito
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

            // CABEÇALHO com avatar e nome do usuário logado
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
                      // Nome do usuário logado
                      Text(
                        usuario?.nome ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Badge com o perfil do usuário (Master ou Administrador)
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

            // CARDS DE MENU — opções disponíveis para todos os ADMs
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

            // Card de Funcionários visível apenas para o perfil master
            if (isMaster)
              _CardMenu(
                icon: Icons.manage_accounts_outlined,
                titulo: 'Funcionários',
                descricao: 'Gerenciar acessos e promover usuários a ADM',
                cor: AppColors.azulMedio, // cor diferenciada para destacar acesso exclusivo
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

  // Exibe diálogo de confirmação antes de encerrar a sessão
  void _confirmarSaida(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          // Cancela e fecha o diálogo sem fazer nada
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          // Confirma o logout, encerra a sessão e redireciona para o login
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.vermelho,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Sessao.encerrar(); // limpa o usuário da sessão
              Navigator.pop(context); // fecha o diálogo
              Navigator.pushReplacementNamed(context, '/login'); // volta para a tela de login
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

// Widget de card reutilizável para cada item do menu administrativo
class _CardMenu extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String descricao;
  final VoidCallback onTap; // ação ao tocar no card
  final Color? cor; // cor opcional para personalizar o card (padrão: azulEscuro)

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
            // Ícone do card com fundo colorido suave
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (cor ?? AppColors.azulEscuro).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: cor ?? AppColors.azulEscuro, // usa cor personalizada se fornecida
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            // Título e descrição do item de menu
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
            // Seta indicando que o card é navegável
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