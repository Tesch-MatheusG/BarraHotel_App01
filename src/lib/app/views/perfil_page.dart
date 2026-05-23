import 'package:flutter/material.dart';
import '../data/sessao.dart';
import 'cores.dart';
import 'editar_perfil_page.dart';

// Página que exibe os dados do perfil do usuário logado
class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém o usuário atualmente logado na sessão
    final usuario = Sessao.usuarioLogado;

    return Scaffold(
      backgroundColor: AppColors.fundoPagina,
      appBar: AppBar(
        backgroundColor: AppColors.azulEscuro,
        foregroundColor: Colors.white,
        title: const Text(
          'Meu Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Cabeçalho azul com avatar e nome do usuário
            Container(
              width: double.infinity,
              color: AppColors.azulEscuro,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: Column(
                children: [
                  // Avatar circular com ícone de pessoa
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 12),
                  // Nome do usuário, exibe string vazia se nulo
                  Text(
                    usuario?.nome ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // E-mail do usuário em cor branca com opacidade reduzida
                  Text(
                    usuario?.email ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Seção com os dados pessoais do usuário
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título da seção de informações pessoais
                  const Text(
                    'Informações Pessoais',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Card com todos os campos de informação do usuário
                  _InfoCard(
                    children: [
                      _InfoItem(
                        icon: Icons.person_outline,
                        label: 'Nome',
                        valor: usuario?.nome ?? '',
                      ),
                      // Linha divisória entre os campos
                      _Divisor(),
                      _InfoItem(
                        icon: Icons.email_outlined,
                        label: 'E-mail',
                        valor: usuario?.email ?? '',
                      ),
                      _Divisor(),
                      _InfoItem(
                        icon: Icons.phone_outlined,
                        label: 'Telefone',
                        valor: usuario?.telefone ?? '',
                      ),
                      _Divisor(),
                      _InfoItem(
                        icon: Icons.badge_outlined,
                        label: 'CPF',
                        valor: usuario?.cpf ?? '',
                      ),
                      _Divisor(),
                      _InfoItem(
                        icon: Icons.location_on_outlined,
                        label: 'CEP',
                        valor: usuario?.cep ?? '',
                      ),
                      _Divisor(),
                      _InfoItem(
                        icon: Icons.home_outlined,
                        label: 'Rua',
                        valor: usuario?.rua ?? '',
                      ),
                      _Divisor(),
                      _InfoItem(
                        icon: Icons.tag,
                        label: 'Número',
                        valor: usuario?.numero ?? '',
                      ),
                      _Divisor(),
                      _InfoItem(
                        icon: Icons.info_outline,
                        label: 'Complemento',
                        valor: usuario?.complemento ?? '',
                      ),
                      _Divisor(),
                      _InfoItem(
                        icon: Icons.location_city,
                        label: 'Bairro',
                        valor: usuario?.bairro ?? '',
                      ),
                      _Divisor(),
                      _InfoItem(
                        icon: Icons.map_outlined,
                        label: 'Município',
                        valor: usuario?.municipio ?? '',
                      ),
                      _Divisor(),
                      _InfoItem(
                        icon: Icons.flag_outlined,
                        label: 'Estado',
                        valor: usuario?.estado ?? '',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Botão que navega para a página de edição do perfil
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditarPerfilPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Alterar Cadastro'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.azulEscuro,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget privado que envolve os itens de informação em um card com borda
class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Borda cinza suave ao redor do card
        border: Border.all(color: AppColors.cinzaBorda),
      ),
      child: Column(children: children),
    );
  }
}

// Widget privado que exibe um campo de informação com ícone, rótulo e valor
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Ícone do campo na cor azul escuro
          Icon(icon, size: 20, color: AppColors.azulEscuro),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rótulo do campo em cinza e tamanho reduzido
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              // Valor do campo; exibe "—" se estiver vazio
              Text(
                valor.isEmpty ? '—' : valor,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget privado que renderiza uma linha divisória entre os itens do card
class _Divisor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Divider com recuo à esquerda para alinhar com o texto dos itens
    return const Divider(height: 1, indent: 48, endIndent: 16);
  }
}