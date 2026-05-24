import 'package:flutter/material.dart';
import 'cores.dart';
import 'drawer_menu.dart';
import '../models/mensagem_model.dart';
import 'bottom_nav.dart';
import '../services/chat_service.dart';

// Página do chatbot com histórico de mensagens e campo de envio
class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController(); // campo de texto do usuário
  final ScrollController _scrollController = ScrollController(); // controla o scroll da lista de mensagens
  static final List<MensagemModel> _mensagens = []; // histórico de mensagens da conversa
  bool _carregando = false; // indica se aguarda resposta do bot
  static final ChatService _chatService = ChatService(); // serviço responsável pela comunicação com a IA

  @override
  void initState() {
    super.initState();
    // Mensagem de boas-vindas exibida ao abrir o chat (apenas se ainda não houver mensagens)
    if (_mensagens.isEmpty) {
      _mensagens.add(MensagemModel(
        texto:
            'Olá! Sou o assistente virtual do Barra Hotel. 😊\n'
            'Posso te ajudar com informações sobre nossos quartos, '
            'reservas e serviços. Como posso te ajudar?',
        isBot: true,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose(); // libera os controllers ao sair da página
    super.dispose();
  }

  // Rola a lista até a última mensagem após o frame ser renderizado
  void _scrollParaBaixo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Envia a mensagem do usuário e aguarda a resposta do chatbot
  Future<void> _enviarMensagem() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty || _carregando) return; // ignora envio vazio ou enquanto carrega

    setState(() {
      _mensagens.add(MensagemModel(texto: texto, isBot: false)); // adiciona mensagem do usuário
      _carregando = true;
      _controller.clear();
    });

    _scrollParaBaixo();

    try {
      final resposta = await _chatService.enviarMensagem(texto); // chama a API do chatbot
      setState(() {
        _mensagens.add(MensagemModel(texto: resposta, isBot: true)); // adiciona resposta do bot
      });
    } catch (e) {
      setState(() {
        String mensagemErro;
        if (e.toString().contains('429')) {
          mensagemErro = 'Limite de uso atingido. Tente novamente mais tarde. 😊';
        } else if (e.toString().contains('400')) {
          mensagemErro = 'Mensagem muito longa. Tente resumir. 😊';
        } else {
          mensagemErro = 'Erro: ${e.toString()}';
        }
        _mensagens.add(MensagemModel(texto: mensagemErro, isBot: true));
      });
    } finally {
      setState(() => _carregando = false); // encerra o estado de carregamento
      _scrollParaBaixo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundoPagina,
      drawer: const DrawerMenu(),
      appBar: AppBar(
        backgroundColor: AppColors.azulEscuro,
        foregroundColor: Colors.white,
        // Título com ícone do bot e nome do hotel
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.smart_toy, size: 18),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assistente Virtual',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Barra Hotel',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      bottomNavigationBar: BottomNav(currentIndex: 2), // aba "Assistente" ativa
      body: Column(
        children: [
          // Lista de mensagens — inclui bolha de digitando ao aguardar resposta
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _mensagens.length + (_carregando ? 1 : 0), // +1 para a bolha de digitando
              itemBuilder: (context, index) {
                if (index == _mensagens.length) {
                  return _BolhaDigitando(); // exibe animação enquanto o bot responde
                }
                return _BolhaMensagem(mensagem: _mensagens[index]);
              },
            ),
          ),
          // Campo de texto e botão de envio na parte inferior
          _CampoEnvio(
            controller: _controller,
            carregando: _carregando,
            onEnviar: _enviarMensagem,
          ),
        ],
      ),
    );
  }
}

// Bolha de mensagem — alinha à esquerda para o bot e à direita para o usuário
class _BolhaMensagem extends StatelessWidget {
  final MensagemModel mensagem;

  const _BolhaMensagem({required this.mensagem});

  @override
  Widget build(BuildContext context) {
    final isBot = mensagem.isBot;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar do bot — exibido apenas nas mensagens do bot
          if (isBot) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                color: AppColors.azulEscuro,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
          // Bolha com o texto da mensagem
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isBot ? Colors.white : AppColors.azulEscuro, // branco para bot, azul para usuário
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isBot ? 4 : 16), // canto reto indica o lado do remetente
                  bottomRight: Radius.circular(isBot ? 16 : 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                mensagem.texto,
                style: TextStyle(
                  fontSize: 14,
                  color: isBot ? const Color(0xFF1A1A1A) : Colors.white,
                  height: 1.4,
                ),
              ),
            ),
          ),
          // Avatar do usuário — exibido apenas nas mensagens do usuário
          if (!isBot) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 8),
              decoration: const BoxDecoration(
                color: AppColors.azulClaro,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.azulEscuro,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Bolha animada exibida enquanto o bot está processando a resposta
class _BolhaDigitando extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Avatar do bot
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              color: AppColors.azulEscuro,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 18,
            ),
          ),
          // Bolha com os três pontos pulsantes
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            // Três pontos com delays diferentes para criar efeito de digitação
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Ponto(delay: 0),
                SizedBox(width: 4),
                _Ponto(delay: 150),
                SizedBox(width: 4),
                _Ponto(delay: 300),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Ponto animado com fade — compõe a animação de digitando do bot
class _Ponto extends StatefulWidget {
  final int delay; // atraso em ms para desincronizar a animação entre os pontos

  const _Ponto({required this.delay});

  @override
  State<_Ponto> createState() => _PontoState();
}

class _PontoState extends State<_Ponto>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    // Aguarda o delay antes de iniciar a animação em loop
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true); // pulsa entre opaco e transparente
    });
    _animation = Tween(begin: 0.4, end: 1.0).animate(_controller); // intervalo de opacidade
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          color: AppColors.azulEscuro,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// Campo de texto e botão de envio fixos na parte inferior da tela
class _CampoEnvio extends StatelessWidget {
  final TextEditingController controller;
  final bool carregando; // desativa o botão enquanto aguarda resposta
  final VoidCallback onEnviar;

  const _CampoEnvio({
    required this.controller,
    required this.carregando,
    required this.onEnviar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2), // sombra para cima, separando do chat
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: (_) => onEnviar(), // envia ao pressionar "enviar" no teclado
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: 'Digite sua mensagem...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: AppColors.fundoPagina,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Botão de envio — desabilitado enquanto aguarda resposta
            Container(
              decoration: const BoxDecoration(
                color: AppColors.azulEscuro,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: carregando ? null : onEnviar,
                icon: const Icon(Icons.send_rounded),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}