import 'package:craft/app/services/web_socket_service.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class ConnectionRepository {
  final WebSocketService _webSocketService = WebSocketService();

  Future<void> connect(String ip, int port, bool alwaysConnect) async {
    await _webSocketService.connect(ip, port);

    if (alwaysConnect) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('ip', ip);
      await prefs.setInt('port', port);
      await prefs.setBool('alwaysConnect', alwaysConnect);
    }
  }

  Future<void> disconnect() async {
    _webSocketService.disconnect();
  }
}
