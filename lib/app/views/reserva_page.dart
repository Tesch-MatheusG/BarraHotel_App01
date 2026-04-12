import 'package:atividadep1/app/viewmodels/quarto_viewmodel.dart';
import 'package:flutter/material.dart';

// PÁGINA DE RESERVA
// Formulário de dados do hóspede + seleção de datas + resumo financeiro
class ReservaPage extends StatefulWidget {
  final Quarto quarto;

  const ReservaPage({super.key, required this.quarto});

  @override
  State<ReservaPage> createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage> {
  // Controladores dos campos de texto
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  DateTime? _checkIn;
  DateTime? _checkOut;
  int _hospedes = 1;

  // Flag para exibir a tela de sucesso
  bool _confirmado = false;

  // Quantidade de noites selecionadas
  int get _noites {
    if (_checkIn == null || _checkOut == null) return 0;
    return _checkOut!.difference(_checkIn!).inDays;
  }

  // Valor total da hospedagem
  double get _total => _noites * widget.quarto.preco;

  // Abre o DatePicker nativo e atualiza check-in ou check-out
  Future<void> _escolherData(bool ehCheckIn) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: ehCheckIn
          ? (_checkIn ?? now)
          : (_checkOut ?? now.add(const Duration(days: 1))),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        // Aplica a cor principal do projeto no calendário
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0D2A7A),
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
          // Garante que checkout não seja anterior ao checkin
          if (_checkOut != null && _checkOut!.isBefore(picked)) {
            _checkOut = picked.add(const Duration(days: 1));
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  // Valida e confirma a reserva
  void _confirmar() {
    if (_nomeController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _checkIn == null ||
        _checkOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos obrigatórios.'),
          backgroundColor: Color(0xFFC40000),
        ),
      );
      return;
    }
    setState(() => _confirmado = true);
  }

  // Formata data para exibição (dd/mm/yyyy)
  String _formatarData(DateTime? d) {
    if (d == null) return 'Selecionar';
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Após confirmação exibe a tela de sucesso
    if (_confirmado) {
      return _TelaSucesso(
        quarto: widget.quarto,
        checkIn: _checkIn!,
        checkOut: _checkOut!,
        nome: _nomeController.text.trim(),
        total: _total,
        noites: _noites,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2A7A),
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
            // Banner com resumo do quarto
            _BannerQuarto(quarto: widget.quarto),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TituloSecao('Datas da Estadia'),
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

                  // Exibe número de noites quando as datas estão preenchidas
                  if (_noites > 0) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF0FB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.nights_stay_outlined,
                            size: 16,
                            color: Color(0xFF0D2A7A),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$_noites noite${_noites > 1 ? 's' : ''} '
                            'selecionada${_noites > 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: Color(0xFF0D2A7A),
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
                  _ContadorHospedes(
                    valor: _hospedes,
                    maximo: widget.quarto.numeroPessoas,
                    onDecrementar:
                        _hospedes > 1 ? () => setState(() => _hospedes--) : null,
                    onIncrementar: _hospedes < widget.quarto.numeroPessoas
                        ? () => setState(() => _hospedes++)
                        : null,
                  ),

                  const SizedBox(height: 20),

                  _TituloSecao('Dados do Hóspede Principal'),
                  _CampoTexto(
                    controller: _nomeController,
                    label: 'Nome completo *',
                    icon: Icons.person_outline,
                    tipo: TextInputType.name,
                  ),
                  const SizedBox(height: 12),
                  _CampoTexto(
                    controller: _emailController,
                    label: 'E-mail *',
                    icon: Icons.email_outlined,
                    tipo: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _CampoTexto(
                    controller: _telefoneController,
                    label: 'Telefone / WhatsApp',
                    icon: Icons.phone_outlined,
                    tipo: TextInputType.phone,
                  ),

                  const SizedBox(height: 24),

                  if (_noites > 0)
                    _ResumoFinanceiro(
                      preco: widget.quarto.preco,
                      noites: _noites,
                      total: _total,
                    ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirmar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D2A7A),
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


class _BannerQuarto extends StatelessWidget {
  final Quarto quarto;

  const _BannerQuarto({required this.quarto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0D2A7A),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
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
                  Text(
                    quarto.nome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    quarto.tipoCama,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 3),
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
          border: Border.all(color: const Color(0xFFDDDDDD)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 13, color: const Color(0xFF0D2A7A)),
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

class _ContadorHospedes extends StatelessWidget {
  final int valor;
  final int maximo;
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
        border: Border.all(color: const Color(0xFFDDDDDD)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                color: Color(0xFF0D2A7A),
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
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: onDecrementar != null
                    ? const Color(0xFF0D2A7A)
                    : Colors.grey,
                onPressed: onDecrementar,
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: onIncrementar != null
                    ? const Color(0xFF0D2A7A)
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

class _CampoTexto extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType tipo;

  const _CampoTexto({
    required this.controller,
    required this.label,
    required this.icon,
    required this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF0D2A7A), size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF0D2A7A),
            width: 1.5,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Color(0xFF777777), fontSize: 13),
      ),
    );
  }
}

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
        border: Border.all(color: const Color(0xFFDDDDDD)),
      ),
      child: Column(
        children: [
          const Text(
            'Resumo da Reserva',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 12),
          _LinhaResumo(
            'R\$ ${preco.toStringAsFixed(0)} × $noites noite${noites > 1 ? 's' : ''}',
            'R\$ ${total.toStringAsFixed(0)}',
          ),
          const Divider(height: 20),
          _LinhaResumo('Total', 'R\$ ${total.toStringAsFixed(0)}',
              negrito: true),
        ],
      ),
    );
  }
}

class _LinhaResumo extends StatelessWidget {
  final String label;
  final String valor;
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
            color:
                negrito ? const Color(0xFF1A1A1A) : const Color(0xFF777777),
          ),
        ),
        Text(
          valor,
          style: TextStyle(
            fontSize: negrito ? 16 : 13,
            fontWeight: negrito ? FontWeight.bold : FontWeight.normal,
            color:
                negrito ? const Color(0xFF0D2A7A) : const Color(0xFF777777),
          ),
        ),
      ],
    );
  }
}

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

              // Ícone de sucesso
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF0FB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF0D2A7A),
                  size: 64,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Reserva Confirmada!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D2A7A),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Olá, $nome! Sua reserva foi registrada com sucesso.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF555555),
                ),
              ),

              const SizedBox(height: 32),

              // Card com os detalhes
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDDDDDD)),
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
                      '$noites noite${noites > 1 ? 's' : ''}',
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total pago',
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
                            color: Color(0xFF0D2A7A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Aviso de e-mail
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

              // Botão voltar ao início
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D2A7A),
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

              TextButton(
                onPressed: () =>
                    Navigator.popUntil(context, ModalRoute.withName('/home')),
                child: const Text(
                  'Ver outros quartos',
                  style: TextStyle(color: Color(0xFF0D2A7A)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Linha de detalhe com ícone, rótulo e valor
class _DetalheItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;

  const _DetalheItem(this.icon, this.label, this.valor);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: const Color(0xFF0D2A7A)),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 13, color: Color(0xFF777777)),
        ),
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