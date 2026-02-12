import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://10.0.2.2:5000/api";

  static Future<List<dynamic>> getRoutes() async {
    final res = await http.get(Uri.parse("$baseUrl/route"));
    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> getBuses(String routeId) async {
    final res = await http.get(Uri.parse("$baseUrl/bus/$routeId"));
    return jsonDecode(res.body);
  }
}
