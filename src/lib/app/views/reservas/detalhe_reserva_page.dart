import 'package:flutter/material.dart';
import '../../data/reserva_mock_store.dart';
import '../../models/reserva_model.dart';
import '../cores.dart';

class DetalheReservaPage extends StatelessWidget {
  final ReservaModel reserva;

  const DetalheReservaPage({super.key, required this.reserva});

  String _formatarData(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundoPagina,
      appBar: AppBar(
        backgroundColor: AppColors.azulEscuro,
        foregroundColor: Colors.white,
        title: const Text(
          'Detalhes da Reserva',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // STATUS
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _corStatus(reserva.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _labelStatus(reserva.status),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _corStatus(reserva.status),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // INFORMAÇÕES DO QUARTO
            _SecaoDetalhes(
              titulo: 'Quarto',
              itens: [
                _ItemDetalhe(Icons.bed_outlined, 'Nome', reserva.nomeQuarto),
                _ItemDetalhe(Icons.king_bed_outlined, 'Cama', reserva.tipoCama),
                _ItemDetalhe(
                  Icons.attach_money,
                  'Diária',
                  'R\$ ${reserva.precoPorNoite.toStringAsFixed(0)}',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // DATAS
            _SecaoDetalhes(
              titulo: 'Estadia',
              itens: [
                _ItemDetalhe(
                  Icons.login,
                  'Check-in',
                  _formatarData(reserva.checkIn),
                ),
                _ItemDetalhe(
                  Icons.logout,
                  'Check-out',
                  _formatarData(reserva.checkOut),
                ),
                _ItemDetalhe(
                  Icons.nights_stay_outlined,
                  'Noites',
                  '${reserva.noites} noite${reserva.noites > 1 ? 's' : ''}',
                ),
                _ItemDetalhe(
                  Icons.person_outline,
                  'Hóspedes',
                  '${reserva.hospedes} hóspede${reserva.hospedes > 1 ? 's' : ''}',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // PAGAMENTO
            _SecaoDetalhes(
              titulo: 'Pagamento',
              itens: [
                _ItemDetalhe(
                  Icons.payments_outlined,
                  'Total',
                  'R\$ ${reserva.total.toStringAsFixed(0)}',
                ),
                _ItemDetalhe(
                  Icons.point_of_sale_outlined,
                  'Forma',
                  'Presencial no check-in/check-out',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // BOTÃO CANCELAR (só aparece se reserva estiver ativa)
            if (reserva.status == StatusReserva.ativa)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _confirmarCancelamento(context),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancelar Reserva'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vermelho,
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
    );
  }

  Color _corStatus(StatusReserva status) {
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

  String _labelStatus(StatusReserva status) {
    switch (status) {
      case StatusReserva.ativa:
        return 'Reserva Ativa';
      case StatusReserva.concluida:
        return 'Reserva Concluída';
      case StatusReserva.cancelada:
        return 'Reserva Cancelada';
      case StatusReserva.emAndamento:
        return 'Em Andamento';
    }
  }

  void _confirmarCancelamento(BuildContext context) {
    final gratis = reserva.podeCancelarGratis;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancelar Reserva'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tem certeza que deseja cancelar esta reserva?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: gratis
                    ? Colors.green.withOpacity(0.1)
                    : AppColors.vermelho.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    gratis ? Icons.check_circle_outline : Icons.warning_outlined,
                    color: gratis ? Colors.green : AppColors.vermelho,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      gratis
                          ? 'Cancelamento gratuito — mais de 48h de antecedência.'
                          : 'Atenção: menos de 48h para o check-in. Pode haver tarifa de cancelamento.',
                      style: TextStyle(
                        fontSize: 12,
                        color: gratis ? Colors.green : AppColors.vermelho,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.vermelho,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              ReservaMockStore.cancelar(reserva.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reserva cancelada.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Confirmar Cancelamento'),
          ),
        ],
      ),
    );
  }
}

class _SecaoDetalhes extends StatelessWidget {
  final String titulo;
  final List<Widget> itens;

  const _SecaoDetalhes({required this.titulo, required this.itens});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cinzaBorda),
          ),
          child: Column(children: itens),
        ),
      ],
    );
  }
}

class _ItemDetalhe extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;

  const _ItemDetalhe(this.icon, this.label, this.valor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.azulEscuro),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}