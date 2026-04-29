import 'package:flutter/material.dart';
import '../../data/reserva_mock_store.dart';
import '../../models/reserva_model.dart';
import '../cores.dart';
import 'detalhe_reserva_page.dart';

class MinhasReservasPage extends StatefulWidget {
  const MinhasReservasPage({super.key});

  @override
  State<MinhasReservasPage> createState() => _MinhasReservasPageState();
}

class _MinhasReservasPageState extends State<MinhasReservasPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          'Minhas Reservas',
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
            Tab(text: 'Anteriores'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ListaReservas(
            reservas: ReservaMockStore.ativas,
            onAtualizar: () => setState(() {}),
          ),
          _ListaReservas(
            reservas: ReservaMockStore.concluidas,
            onAtualizar: () => setState(() {}),
          ),
        ],
      ),
    );
  }
}

class _ListaReservas extends StatelessWidget {
  final List<ReservaModel> reservas;
  final VoidCallback onAtualizar;

  const _ListaReservas({
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
        return _CardReserva(
          reserva: reservas[index],
          onAtualizar: onAtualizar,
        );
      },
    );
  }
}

class _CardReserva extends StatelessWidget {
  final ReservaModel reserva;
  final VoidCallback onAtualizar;

  const _CardReserva({
    required this.reserva,
    required this.onAtualizar,
  });

  String _formatarData(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  Color get _corStatus {
    switch (reserva.status) {
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

  String get _labelStatus {
    switch (reserva.status) {
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cinzaBorda),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _corStatus.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _labelStatus,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _corStatus,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // DATAS
            Row(
              children: [
                _InfoReserva(
                  icon: Icons.login,
                  label: 'Check-in',
                  valor: _formatarData(reserva.checkIn),
                ),
                const SizedBox(width: 24),
                _InfoReserva(
                  icon: Icons.logout,
                  label: 'Check-out',
                  valor: _formatarData(reserva.checkOut),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // NOITES + TOTAL
            Row(
              children: [
                _InfoReserva(
                  icon: Icons.nights_stay_outlined,
                  label: 'Noites',
                  valor: '${reserva.noites}',
                ),
                const SizedBox(width: 24),
                _InfoReserva(
                  icon: Icons.attach_money,
                  label: 'Total',
                  valor: 'R\$ ${reserva.total.toStringAsFixed(0)}',
                ),
              ],
            ),

            const SizedBox(height: 14),

            // BOTÃO DETALHES
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalheReservaPage(reserva: reserva),
                    ),
                  );
                  onAtualizar();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.azulEscuro,
                  side: const BorderSide(color: AppColors.azulEscuro),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Ver Detalhes',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoReserva extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;

  const _InfoReserva({
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