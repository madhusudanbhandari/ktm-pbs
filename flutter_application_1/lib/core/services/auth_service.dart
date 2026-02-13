import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const baseUrl = "http://localhost:5000/api/auth";

  static Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
    required String role,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
          "address": address,
          "role": role,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        print("Error response: ${res.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<Map?> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return null;
  }
}
