import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/hotel_knowledge.dart';

class ChatService {
  // Pegue sua chave em: https://aistudio.google.com/app/apikey
  static const _apiKey = 'AIzaSyC44DpMDTQLDgDtYsUVuvERI196xwH1E6k';
  static const _url =
      'https://generativelanguage.googleapis.com/v1beta/models/'
      'gemini-2.0-flash:generateContent?key=$_apiKey';

  // Histórico da conversa (sem o system prompt)
  final List<Map<String, dynamic>> _historico = [];

  Future<String> enviarMensagem(String textoUsuario) async {
    // Adiciona a mensagem do usuário ao histórico
    _historico.add({
      'role': 'user',
      'parts': [{'text': textoUsuario}]
    });

    final body = jsonEncode({
      'system_instruction': {
        'parts': [{'text': hotelSystemPrompt}]
      },
      'contents': _historico,
    });

    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final resposta = data['candidates'][0]['content']['parts'][0]['text']
          as String;

      // Salva a resposta do bot no histórico
      _historico.add({
        'role': 'model',
        'parts': [{'text': resposta}]
      });

      return resposta;
    } else {
      throw Exception('Erro na API: ${response.statusCode}');
    }
  }
}