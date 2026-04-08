import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.13.198.52:5000";

  static Future<Map<String, dynamic>> predict(String imageBase64) async {
    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "image": imageBase64,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception("Backend error: ${response.body}");
    }
  }

  static Future<void> clear() async {
    final response = await http.post(Uri.parse('$baseUrl/clear'));

    if (response.statusCode != 200) {
      throw Exception("Clear failed: ${response.body}");
    }
  }

  static Future<void> speak(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/speak'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "text": text,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Speak failed: ${response.body}");
    }
  }
}