import 'package:flutter/material.dart';
import '../../data/reserva_mock_store.dart';
import '../../models/reserva_model.dart';
import '../cores.dart';

class AdmReservasPage extends StatefulWidget {
  const AdmReservasPage({super.key});

  @override
  State<AdmReservasPage> createState() => _AdmReservasPageState();
}

class _AdmReservasPageState extends State<AdmReservasPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          _ListaReservasAdm(
            reservas: ReservaMockStore.todas
            .where((r) =>
            r.status == StatusReserva.ativa ||
            r.status == StatusReserva.emAndamento)
            .toList(),
            onAtualizar: () => setState(() {}),
          ),
          _ListaReservasAdm(
            reservas: ReservaMockStore.todas
                .where((r) => r.status == StatusReserva.concluida)
                .toList(),
            onAtualizar: () => setState(() {}),
          ),
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

class _ListaReservasAdm extends StatelessWidget {
  final List<ReservaModel> reservas;
  final VoidCallback onAtualizar;

  const _ListaReservasAdm({
    required this.reservas,
    required this.onAtualizar,
  });

  @override
  Widget build(BuildContext context) {
    if (reservas.isEmpty) {
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

class _CardReservaAdm extends StatelessWidget {
  final ReservaModel reserva;
  final VoidCallback onAtualizar;

  const _CardReservaAdm({
    required this.reserva,
    required this.onAtualizar,
  });

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

          // NOME DO QUARTO + STATUS
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
              _ChipStatus(status: reserva.status),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // DATAS
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

          // AÇÕES (só para reservas ativas)
          if (reserva.status == StatusReserva.ativa) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
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
              ReservaMockStore.confirmarCheckin(reserva.id);
              Navigator.pop(context);
              onAtualizar();
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
              ReservaMockStore.confirmarCheckout(reserva.id);
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
              ReservaMockStore.registrarPagamento(reserva.id);
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

class _ChipStatus extends StatelessWidget {
  final StatusReserva status;

  const _ChipStatus({required this.status});

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
        color: _cor.withOpacity(0.1),
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
              style: const TextStyle(fontSize: 10, color: Colors.grey),
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