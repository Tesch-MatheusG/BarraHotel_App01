import '../models/reserva_model.dart';

// Armazenamento temporário de reservas em memória (mock, sem banco de dados)
class ReservaMockStore {
  static final List<ReservaModel> _reservas = []; // lista privada de todas as reservas

  // Adiciona uma nova reserva à lista
  static void adicionar(ReservaModel reserva) {
    _reservas.add(reserva);
  }

  // Retorna todas as reservas como lista imutável (somente leitura)
  static List<ReservaModel> get todas => List.unmodifiable(_reservas);

  // Retorna apenas as reservas com status ativo
  static List<ReservaModel> get ativas =>
      _reservas.where((r) => r.status == StatusReserva.ativa).toList();

  // Retorna reservas concluídas e canceladas (histórico)
  static List<ReservaModel> get concluidas =>
      _reservas
        .where((r) => 
          r.status == StatusReserva.concluida ||
          r.status == StatusReserva.cancelada)
      .toList();

  // Cancela uma reserva pelo ID
  static void cancelar(String id) {
    final reserva = _reservas.firstWhere((r) => r.id == id); // busca reserva pelo id
    reserva.status = StatusReserva.cancelada; // atualiza status para cancelada
  }

  // Confirma o check-in, colocando a reserva em andamento
  static void confirmarCheckin(String id) {
    final reserva = _reservas.firstWhere((r) => r.id == id);
    reserva.status = StatusReserva.emAndamento; // hóspede entrou no quarto
  }

  // Confirma o check-out, marcando a reserva como concluída
  static void confirmarCheckout(String id) {
    final reserva = _reservas.firstWhere((r) => r.id == id);
    reserva.status = StatusReserva.concluida; // hóspede saiu do quarto
  }

  // Registra o pagamento de uma reserva pelo ID
  static void registrarPagamento(String id) {
    final reserva = _reservas.firstWhere((r) => r.id == id);
    reserva.pago = true; // marca reserva como paga
  }
}