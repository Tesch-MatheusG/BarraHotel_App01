import '../models/reserva_model.dart';

class ReservaMockStore {
  static final List<ReservaModel> _reservas = [];

  static void adicionar(ReservaModel reserva) {
    _reservas.add(reserva);
  }

  static List<ReservaModel> get todas => List.unmodifiable(_reservas);

  static List<ReservaModel> get ativas =>
      _reservas.where((r) => r.status == StatusReserva.ativa).toList();

  static List<ReservaModel> get concluidas =>
      _reservas.where((r) => r.status == StatusReserva.concluida).toList();

  static void cancelar(String id) {
    final reserva = _reservas.firstWhere((r) => r.id == id);
    reserva.status = StatusReserva.cancelada;
  }
}