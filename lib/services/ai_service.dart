import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String baseUrl = "http://10.0.2.2:8000"; // Android emulator

  static Future<Map<String, dynamic>> getFeedback(double score) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai/feedback'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'score': score}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('AI server error');
    }
  }
}
