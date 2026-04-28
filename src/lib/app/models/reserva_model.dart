enum StatusReserva { ativa, concluida, cancelada }

class ReservaModel {
  final String id;
  final String nomeQuarto;
  final String tipoCama;
  final double precoPorNoite;
  final DateTime checkIn;
  final DateTime checkOut;
  final int hospedes;
  final double total;
  StatusReserva status;

  ReservaModel({
    required this.id,
    required this.nomeQuarto,
    required this.tipoCama,
    required this.precoPorNoite,
    required this.checkIn,
    required this.checkOut,
    required this.hospedes,
    required this.total,
    this.status = StatusReserva.ativa,
  });

  int get noites => checkOut.difference(checkIn).inDays;

  bool get podeCancelarGratis =>
      checkIn.difference(DateTime.now()).inHours >= 48;
}