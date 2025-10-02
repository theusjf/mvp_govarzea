import 'package:http/http.dart' as http;
import '../models/time_model.dart';

class TimeController {
  final Time time;

  TimeController(this.time);

  Future<String?> buscarFoto() async {
    if (time.idTime == null) return null;

    final url = 'http://152.70.216.121:8089/v1/time/${time.idTime}/foto/url';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response.body;
      }
    } catch (_) {
    }
    return null;
  }
}
