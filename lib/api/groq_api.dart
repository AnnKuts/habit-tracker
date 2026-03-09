import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqApi {
  static String get _apiUrl =>
      dotenv.env['GROQ_API_URL'] ??
      'https://api.groq.com/openai/v1/chat/completions';

  static String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';

  static Future<String> fetchAIResponse(String prompt) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        if (_apiKey.isNotEmpty) 'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'llama-3.1-8b-instant',
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode == 200) {
      return parseJson(response.body);
    } else {
      throw Exception(
        'Groq request failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  static String parseJson(String source) {
    final decoded = jsonDecode(source);

    return decoded['choices']?[0]?['message']?['content'] ?? '';
  }
}
