import 'dart:async';

import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();

  final Logger _logger = Logger('WebSocketService');

  WebSocketChannel? _channel;
  final Map<String, StreamController<dynamic>> _streamControllers = {};

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal();

  Future<void> connect(String ip, int port) async {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://$ip:$port/chat'),
    );

    _logger.info('Connected to ws://$ip:$port/chat');

    _channel?.stream.listen((event) {
      _logger.info('Received message: $event');

      _streamControllers.forEach((key, controller) {
        controller.add(event);
      });
    });

    return _channel?.ready;
  }

  void sendMessage(String message) {
    _logger.info('Sending message: $message');
    _channel?.sink.add(message);
  }

  Stream<dynamic> getStream(String key) {
    if (!_streamControllers.containsKey(key)) {
      _streamControllers[key] = StreamController<dynamic>.broadcast();
    }
    return _streamControllers[key]!.stream;
  }

  void closeStream(String key) {
    _streamControllers[key]?.close();
    _streamControllers.remove(key);
  }

  void disconnect() {
    _logger.info('Disconnecting...');

    _channel?.sink.close();
    _streamControllers.forEach((key, controller) {
      controller.close();
    });
    _streamControllers.clear();
  }
}
