import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../data/hotel_knowledge.dart';

class ChatService {
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get _url =>
      'https://generativelanguage.googleapis.com/v1beta/models/'
      'gemini-2.5-flash:generateContent?key=$_apiKey';

  // Histórico da conversa (sem o system prompt)
  final List<Map<String, dynamic>> _historico = [];

  Future<String> enviarMensagem(String textoUsuario) async {
    _historico.add({
      'role': 'user',
      'parts': [{'text': textoUsuario}]
    });

    // Limita o histórico enviado às últimas 10 mensagens
    final historicoRecente = _historico.length > 10
        ? _historico.sublist(_historico.length - 10)
        : List.from(_historico);

    final body = jsonEncode({
      'system_instruction': {
        'parts': [{'text': hotelSystemPrompt}]
      },
      'contents': historicoRecente,
    });

    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final resposta = data['candidates'][0]['content']['parts'][0]['text'] as String;

      _historico.add({
        'role': 'model',
        'parts': [{'text': resposta}]
      });

      return resposta;
    } else {
      throw Exception('Erro ${response.statusCode}');
    }
  }
}