import 'package:atividadep1/app/viewmodels/quarto_viewmodel.dart';
import 'package:flutter/material.dart';
import '../data/sessao.dart';
import '../views/cores.dart';
import '../data/reserva_mock_store.dart';
import '../models/reserva_model.dart';

// Página de formulário para realização de uma reserva
// Exibe dados do quarto, seleção de datas, número de hóspedes e resumo financeiro
class ReservaPage extends StatefulWidget {
  // Quarto selecionado pelo usuário para reserva
  final Quarto quarto;

  const ReservaPage({super.key, required this.quarto});

  @override
  State<ReservaPage> createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage> {

  // Obtém o nome do usuário logado na sessão atual
  String get _nomeUsuario => Sessao.usuarioLogado?.nome ?? '';

  // Datas de check-in e check-out selecionadas pelo usuário
  DateTime? _checkIn;
  DateTime? _checkOut;
  // Número de hóspedes, começa com 1 por padrão
  int _hospedes = 1;

  // Flag que controla a exibição da tela de confirmação de sucesso
  bool _confirmado = false;

  // Calcula a quantidade de noites com base nas datas selecionadas
  int get _noites {
    if (_checkIn == null || _checkOut == null) return 0;
    return _checkOut!.difference(_checkIn!).inDays;
  }

  // Calcula o valor total multiplicando noites pelo preço do quarto
  double get _total => _noites * widget.quarto.preco;

  // Abre o DatePicker nativo e atualiza check-in ou check-out conforme o parâmetro
  Future<void> _escolherData(bool ehCheckIn) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      // Define a data inicial do calendário dependendo do campo aberto
      initialDate: ehCheckIn
          ? (_checkIn ?? now)
          : (_checkOut ?? now.add(const Duration(days: 1))),
      // Não permite selecionar datas passadas
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        // Aplica a paleta de cores do projeto no calendário nativo
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.azulEscuro,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (ehCheckIn) {
          _checkIn = picked;
          // Ajusta o check-out automaticamente se for anterior ao novo check-in
          if (_checkOut != null && _checkOut!.isBefore(picked)) {
            _checkOut = picked.add(const Duration(days: 1));
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  // Valida os campos obrigatórios, cria a reserva e salva no mock store
  void _confirmar() {
    // Exibe erro se alguma das datas não foi preenchida
    if (_checkIn == null || _checkOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos obrigatórios.'),
          backgroundColor: Color(0xFFC40000),
        ),
      );
      return;
    }
    // Cria o objeto de reserva com os dados preenchidos
    final reserva = ReservaModel(
      // Usa timestamp como ID único da reserva
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nomeQuarto: widget.quarto.nome,
      tipoCama: widget.quarto.tipoCama,
      precoPorNoite: widget.quarto.preco,
      checkIn: _checkIn!,
      checkOut: _checkOut!,
      hospedes: _hospedes,
      total: _total,
    );

    // Persiste a reserva no mock store em memória
    ReservaMockStore.adicionar(reserva);
    // Atualiza o estado para exibir a tela de sucesso
    setState(() => _confirmado = true);
  }

  // Formata um objeto DateTime para o padrão brasileiro dd/mm/yyyy
  String _formatarData(DateTime? d) {
    if (d == null) return 'Selecionar';
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Se a reserva foi confirmada, exibe a tela de sucesso em vez do formulário
    if (_confirmado) {
      return _TelaSucesso(
        quarto: widget.quarto,
        checkIn: _checkIn!,
        checkOut: _checkOut!,
        nome: _nomeUsuario,
        total: _total,
        noites: _noites,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.fundoPagina,
      appBar: AppBar(
        backgroundColor: AppColors.azulEscuro,
        foregroundColor: Colors.white,
        title: const Text(
          'Confirmar Reserva',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner no topo com nome, tipo de cama e preço do quarto
            _BannerQuarto(quarto: widget.quarto),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TituloSecao('Datas da Estadia'),
                  // Linha com os dois seletores de data lado a lado
                  Row(
                    children: [
                      Expanded(
                        child: _SeletorData(
                          label: 'Check-in',
                          valor: _formatarData(_checkIn),
                          icon: Icons.login,
                          onTap: () => _escolherData(true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SeletorData(
                          label: 'Check-out',
                          valor: _formatarData(_checkOut),
                          icon: Icons.logout,
                          onTap: () => _escolherData(false),
                        ),
                      ),
                    ],
                  ),

                  // Exibe o total de noites selecionadas somente quando > 0
                  if (_noites > 0) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.azulClaro,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.nights_stay_outlined,
                            size: 16,
                            color: AppColors.azulEscuro,
                          ),
                          const SizedBox(width: 6),
                          // Texto com plural condicional para "noite/noites"
                          Text(
                            '$_noites noite${_noites > 1 ? 's' : ''} '
                            'selecionada${_noites > 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: AppColors.azulEscuro,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  _TituloSecao('Número de Hóspedes'),
                  // Contador de hóspedes limitado pela capacidade do quarto
                  _ContadorHospedes(
                    valor: _hospedes,
                    maximo: widget.quarto.numeroPessoas,
                    // Desabilita o botão de decrementar se já está no mínimo (1)
                    onDecrementar:
                        _hospedes > 1 ? () => setState(() => _hospedes--) : null,
                    // Desabilita o botão de incrementar se atingiu a capacidade máxima
                    onIncrementar: _hospedes < widget.quarto.numeroPessoas
                        ? () => setState(() => _hospedes++)
                        : null,
                  ),

                  const SizedBox(height: 20),

                  _TituloSecao('Hóspede Principal'),
                  // Card exibindo o nome do usuário logado como hóspede principal
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFDDDDDD)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: AppColors.azulEscuro, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          _nomeUsuario,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Exibe o resumo financeiro apenas quando há noites selecionadas
                  if (_noites > 0)
                    _ResumoFinanceiro(
                      preco: widget.quarto.preco,
                      noites: _noites,
                      total: _total,
                    ),

                  const SizedBox(height: 24),

                  // Botão principal que aciona a confirmação da reserva
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirmar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.azulEscuro,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirmar Reserva',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Aviso sobre termos de uso centralizado abaixo do botão
                  Center(
                    child: Text(
                      'Ao confirmar, você concorda com os termos de '
                      'uso e política de cancelamento.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
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

// Banner exibido no topo da página com as informações resumidas do quarto
class _BannerQuarto extends StatelessWidget {
  final Quarto quarto;

  const _BannerQuarto({required this.quarto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.azulEscuro,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          // Fundo semi-transparente sobre o azul escuro
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Ícone de cama dentro de um container arredondado
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.bed, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome do quarto em negrito
                  Text(
                    quarto.nome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Tipo de cama em cor levemente transparente
                  Text(
                    quarto.tipoCama,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Preço por noite formatado
                  Text(
                    'R\$ ${quarto.preco.toStringAsFixed(0)}/noite',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de botão para seleção de data (check-in ou check-out)
class _SeletorData extends StatelessWidget {
  final String label;
  final String valor;
  final IconData icon;
  final VoidCallback onTap;

  const _SeletorData({
    required this.label,
    required this.valor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cinzaBorda),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linha com ícone e rótulo do campo
            Row(
              children: [
                Icon(icon, size: 13, color: AppColors.azulEscuro),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Valor da data; cinza quando ainda não selecionada
            Text(
              valor,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valor == 'Selecionar'
                    ? Colors.grey
                    : const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget com botões de incremento e decremento para o número de hóspedes
class _ContadorHospedes extends StatelessWidget {
  final int valor;
  // Capacidade máxima do quarto
  final int maximo;
  // Callbacks nulos desabilitam os botões nos limites mínimo e máximo
  final VoidCallback? onDecrementar;
  final VoidCallback? onIncrementar;

  const _ContadorHospedes({
    required this.valor,
    required this.maximo,
    required this.onDecrementar,
    required this.onIncrementar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cinzaBorda),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Exibe quantidade atual com plural condicional
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                color: AppColors.azulEscuro,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '$valor hóspede${valor > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // Botões de controle; ficam cinzas quando desabilitados
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: onDecrementar != null
                    ? AppColors.azulEscuro
                    : Colors.grey,
                onPressed: onDecrementar,
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: onIncrementar != null
                    ? AppColors.azulEscuro
                    : Colors.grey,
                onPressed: onIncrementar,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget com o resumo financeiro da reserva (preço × noites + total)
class _ResumoFinanceiro extends StatelessWidget {
  final double preco;
  final int noites;
  final double total;

  const _ResumoFinanceiro({
    required this.preco,
    required this.noites,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cinzaBorda),
      ),
      child: Column(
        children: [
          const Text(
            'Resumo da Reserva',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 12),
          // Linha com cálculo: preço × número de noites
          _LinhaResumo(
            'R\$ ${preco.toStringAsFixed(0)} × $noites noite${noites > 1 ? 's' : ''}',
            'R\$ ${total.toStringAsFixed(0)}',
          ),
          const Divider(height: 20),
          // Linha do total em negrito
          _LinhaResumo('Total', 'R\$ ${total.toStringAsFixed(0)}',
              negrito: true),
        ],
      ),
    );
  }
}

// Linha de texto com rótulo e valor usada no resumo financeiro
class _LinhaResumo extends StatelessWidget {
  final String label;
  final String valor;
  // Quando verdadeiro, aplica estilo em negrito e tamanho maior
  final bool negrito;

  const _LinhaResumo(this.label, this.valor, {this.negrito = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: negrito ? 15 : 13,
            fontWeight: negrito ? FontWeight.bold : FontWeight.normal,
            // Linha de total usa cor escura; demais linhas usam cinza
            color: negrito ? const Color(0xFF1A1A1A) : AppColors.cinzaTexto,
          ),
        ),
        Text(
          valor,
          style: TextStyle(
            fontSize: negrito ? 16 : 13,
            fontWeight: negrito ? FontWeight.bold : FontWeight.normal,
            // Valor do total usa azul escuro para destaque
            color: negrito ? AppColors.azulEscuro : AppColors.cinzaTexto,
          ),
        ),
      ],
    );
  }
}

// Título de seção reutilizado ao longo do formulário
class _TituloSecao extends StatelessWidget {
  final String texto;

  const _TituloSecao(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        texto,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}

// Tela exibida após a confirmação bem-sucedida da reserva
class _TelaSucesso extends StatelessWidget {
  final Quarto quarto;
  final DateTime checkIn;
  final DateTime checkOut;
  final String nome;
  final double total;
  final int noites;

  const _TelaSucesso({
    required this.quarto,
    required this.checkIn,
    required this.checkOut,
    required this.nome,
    required this.total,
    required this.noites,
  });

  // Formata DateTime para o padrão dd/mm/yyyy
  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Ícone circular de check indicando sucesso
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF0FB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.azulEscuro,
                  size: 64,
                ),
              ),

              const SizedBox(height: 24),

              // Título de confirmação em destaque
              const Text(
                'Reserva Confirmada!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.azulEscuro,
                ),
              ),

              const SizedBox(height: 8),

              // Mensagem personalizada com o nome do hóspede
              Text(
                'Olá, $nome! Sua reserva foi registrada com sucesso.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF555555),
                ),
              ),

              const SizedBox(height: 32),

              // Card com os detalhes completos da reserva confirmada
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.fundoPagina,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cinzaBorda),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detalhes da Reserva',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _DetalheItem(Icons.bed_outlined, 'Quarto', quarto.nome),
                    const SizedBox(height: 10),
                    _DetalheItem(Icons.login, 'Check-in', _fmt(checkIn)),
                    const SizedBox(height: 10),
                    _DetalheItem(Icons.logout, 'Check-out', _fmt(checkOut)),
                    const SizedBox(height: 10),
                    _DetalheItem(
                      Icons.nights_stay_outlined,
                      'Noites',
                      // Plural condicional para "noite/noites"
                      '$noites noite${noites > 1 ? 's' : ''}',
                    ),
                    const Divider(height: 24),
                    // Linha de total com destaque visual
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total (Pago no Check-in)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'R\$ ${total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.azulEscuro,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Aviso amarelo informando que o e-mail de confirmação será enviado
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFE082)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFFF57F17), size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Em breve você receberá a confirmação por e-mail '
                        'com todos os detalhes.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Botão principal que retorna para a tela inicial
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.azulEscuro,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Voltar ao Início',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Link secundário para voltar à listagem de quartos
              TextButton(
                onPressed: () =>
                    Navigator.popUntil(context, ModalRoute.withName('/home')),
                child: const Text(
                  'Ver outros quartos',
                  style: TextStyle(color: AppColors.azulEscuro),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget que exibe uma linha de detalhe com ícone, rótulo e valor
class _DetalheItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;

  const _DetalheItem(this.icon, this.label, this.valor);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Ícone na cor azul escuro do projeto
        Icon(icon, size: 17, color: AppColors.azulEscuro),
        const SizedBox(width: 10),
        // Rótulo em cinza seguido de dois-pontos
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 13, color: Color(0xFF777777)),
        ),
        // Valor em negrito com reticências se ultrapassar o espaço disponível
        Expanded(
          child: Text(
            valor,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}