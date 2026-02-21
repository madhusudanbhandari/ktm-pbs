import 'dart:convert';
import 'package:http/http.dart' as http;

class RouteServices {
  static const baseUrl = "http://localhost:5000/api/route";

  static Future<bool> addRoute(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/routes/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return res.statusCode == 201;
  }

  static Future<List<dynamic>> getRoutes() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return [];
    }
  }

  static Future<bool> addStop(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/stops/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return res.statusCode == 201;
  }
}
