import 'dart:convert';
import 'package:http/http.dart' as http;

class BusService {
  static const baseUrl = "http://localhost:5000/api/bus";

  static Future<List> getBusesByRoute(String routeId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/$routeId"),
      headers: {"Content-Type": "application/json"},
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return [];
  }

  static Future<bool> addBus(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }
}
