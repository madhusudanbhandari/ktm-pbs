import 'dart:convert';
import 'package:http/http.dart' as http;

class RouteServices {
  static const baseUrl = "http://localhost:5000/api/route";

  static Future<List<dynamic>> getRoutes() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return [];
    }
  }
}
