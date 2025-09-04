import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/time_model.dart';

class EditarTimeController {
  final String baseUrl = "http://167.234.248.188:8080/v1/time";

  Future<bool> updateTime(Time time) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${time.idTime}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(time.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
