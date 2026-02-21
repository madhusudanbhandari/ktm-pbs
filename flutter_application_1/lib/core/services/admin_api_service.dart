import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminApiService {
  static const String baseUrl = "http://localhost:5000/api";

  // ================= BUS APIs =================
  static Future<bool> addBus(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/buses/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return res.statusCode == 201;
  }

  static Future<List<dynamic>> getBuses() async {
    final res = await http.get(Uri.parse("$baseUrl/buses"));
    return jsonDecode(res.body);
  }

  static Future<void> deleteBus(String id) async {
    await http.delete(Uri.parse("$baseUrl/buses/$id"));
  }

  // ================= ROUTE APIs =================
  static Future<bool> addRoute(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/routes/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return res.statusCode == 201;
  }

  static Future<List<dynamic>> getRoutes() async {
    final res = await http.get(Uri.parse("$baseUrl/routes"));
    return jsonDecode(res.body);
  }

  // ================= STOP APIs =================
  static Future<bool> addStop(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/stops/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return res.statusCode == 201;
  }
}
