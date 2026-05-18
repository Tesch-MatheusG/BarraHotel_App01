import 'package:flutter/material.dart';
import '../../data/reserva_mock_store.dart';
import '../../models/reserva_model.dart';
import '../cores.dart';

// Página de gerenciamento de reservas dividida em 3 abas: Ativas, Concluídas e Canceladas
class AdmReservasPage extends StatefulWidget {
  const AdmReservasPage({super.key});

  @override
  State<AdmReservasPage> createState() => _AdmReservasPageState();
}

class _AdmReservasPageState extends State<AdmReservasPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // controla a navegação entre as 3 abas

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 abas fixas
  }

  @override
  void dispose() {
    _tabController.dispose(); // libera o controller ao sair da página
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundoPagina,
      appBar: AppBar(
        backgroundColor: AppColors.azulEscuro,
        foregroundColor: Colors.white,
        title: const Text(
          'Reservas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Ativas'),
            Tab(text: 'Concluídas'),
            Tab(text: 'Canceladas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Aba 1: reservas ativas e em andamento
          _ListaReservasAdm(
            reservas: ReservaMockStore.todas
                .where((r) =>
                    r.status == StatusReserva.ativa ||
                    r.status == StatusReserva.emAndamento)
                .toList(),
            onAtualizar: () => setState(() {}),
          ),
          // Aba 2: reservas concluídas
          _ListaReservasAdm(
            reservas: ReservaMockStore.todas
                .where((r) => r.status == StatusReserva.concluida)
                .toList(),
            onAtualizar: () => setState(() {}),
          ),
          // Aba 3: reservas canceladas
          _ListaReservasAdm(
            reservas: ReservaMockStore.todas
                .where((r) => r.status == StatusReserva.cancelada)
                .toList(),
            onAtualizar: () => setState(() {}),
          ),
        ],
      ),
    );
  }
}

// Lista as reservas de uma aba, exibindo estado vazio se não houver nenhuma
class _ListaReservasAdm extends StatelessWidget {
  final List<ReservaModel> reservas;
  final VoidCallback onAtualizar; // callback para reconstruir a tela após ações

  const _ListaReservasAdm({
    required this.reservas,
    required this.onAtualizar,
  });

  @override
  Widget build(BuildContext context) {
    if (reservas.isEmpty) {
      // estado vazio — nenhuma reserva nesta aba
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Nenhuma reserva encontrada.',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reservas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _CardReservaAdm(
          reserva: reservas[index],
          onAtualizar: onAtualizar,
        );
      },
    );
  }
}

// Card individual de cada reserva com dados e ações disponíveis
class _CardReservaAdm extends StatelessWidget {
  final ReservaModel reserva;
  final VoidCallback onAtualizar;

  const _CardReservaAdm({
    required this.reserva,
    required this.onAtualizar,
  });

  // Formata uma data para o padrão dd/mm/aaaa
  String _formatarData(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // NOME DO QUARTO e CHIP de status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  reserva.nomeQuarto,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              _ChipStatus(status: reserva.status), // badge colorida com o status atual
            ],
          ),

          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // DATAS de check-in e check-out
          Row(
            children: [
              _InfoItem(
                icon: Icons.login,
                label: 'Check-in',
                valor: _formatarData(reserva.checkIn),
              ),
              const SizedBox(width: 24),
              _InfoItem(
                icon: Icons.logout,
                label: 'Check-out',
                valor: _formatarData(reserva.checkOut),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // QUANTIDADE DE NOITES e VALOR TOTAL
          Row(
            children: [
              _InfoItem(
                icon: Icons.nights_stay_outlined,
                label: 'Noites',
                valor: '${reserva.noites}',
              ),
              const SizedBox(width: 24),
              _InfoItem(
                icon: Icons.attach_money,
                label: 'Total',
                valor: 'R\$ ${reserva.total.toStringAsFixed(0)}',
              ),
            ],
          ),

          // BOTÕES DE AÇÃO — visíveis apenas para reservas com status ativo
          if (reserva.status == StatusReserva.ativa || reserva.status == StatusReserva.emAndamento) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                // Botão de check-in
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmarCheckin(context),
                    icon: const Icon(Icons.login, size: 16),
                    label: const Text('Check-in'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Botão de check-out
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmarCheckout(context),
                    icon: const Icon(Icons.logout, size: 16),
                    label: const Text('Check-out'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.azulEscuro,
                      side: const BorderSide(color: AppColors.azulEscuro),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Botão de registrar pagamento
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmarPagamento(context),
                    icon: const Icon(Icons.payments_outlined, size: 16),
                    label: const Text('Pago'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.azulEscuro,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // Diálogo de confirmação do check-in
  void _confirmarCheckin(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar Check-in'),
        content: Text(
          'Confirmar check-in para o quarto "${reserva.nomeQuarto}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              ReservaMockStore.confirmarCheckin(reserva.id); // atualiza status para emAndamento
              Navigator.pop(context);
              onAtualizar(); // reconstrói a lista
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Check-in confirmado!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  // Diálogo de confirmação do check-out
  void _confirmarCheckout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar Check-out'),
        content: Text(
          'Confirmar check-out para o quarto "${reserva.nomeQuarto}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.azulEscuro,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              ReservaMockStore.confirmarCheckout(reserva.id); // atualiza status para concluida
              Navigator.pop(context);
              onAtualizar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Check-out confirmado!'),
                  backgroundColor: AppColors.azulEscuro,
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  // Diálogo de confirmação do pagamento com valor total da reserva
  void _confirmarPagamento(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrar Pagamento'),
        content: Text(
          'Confirmar pagamento de R\$ ${reserva.total.toStringAsFixed(0)} '
          'para o quarto "${reserva.nomeQuarto}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.azulEscuro,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              ReservaMockStore.registrarPagamento(reserva.id); // marca reserva como paga
              Navigator.pop(context);
              onAtualizar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pagamento registrado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

// Badge colorida que exibe o status atual da reserva
class _ChipStatus extends StatelessWidget {
  final StatusReserva status;

  const _ChipStatus({required this.status});

  // Define a cor da badge conforme o status
  Color get _cor {
    switch (status) {
      case StatusReserva.ativa:
        return Colors.green;
      case StatusReserva.concluida:
        return Colors.blue;
      case StatusReserva.cancelada:
        return AppColors.vermelho;
      case StatusReserva.emAndamento:
        return Colors.orange;
    }
  }

  // Define o texto da badge conforme o status
  String get _label {
    switch (status) {
      case StatusReserva.ativa:
        return 'Ativa';
      case StatusReserva.concluida:
        return 'Concluída';
      case StatusReserva.cancelada:
        return 'Cancelada';
      case StatusReserva.emAndamento:
        return 'Em Andamento';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _cor.withOpacity(0.1), // fundo suave com a cor do status
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _cor,
        ),
      ),
    );
  }
}

// Widget reutilizável para exibir um dado com ícone, label e valor
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
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.azulEscuro),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey), // label menor e discreto
            ),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}