import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static late WebSocketChannel? _channel;

  static final WebSocketService _instance = WebSocketService._internal();

  factory WebSocketService() {
    return _instance;
  }

  factory WebSocketService.instance() {
    return _instance;
  }

  WebSocketService._internal();

  Future<void> connect(String ip, int port) async {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://$ip:$port/chat'),
    );

    return _channel?.ready;
  }

  void sendMessage(String message) {
    _channel?.sink.add(message);
  }

  Stream<String>? get messages =>
      _channel?.stream.map((event) => event.toString());

  Stream<dynamic> get stream => _channel!.stream;

  void disconnect() {
    _channel?.sink.close();
  }
}
