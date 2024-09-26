import 'dart:convert';

import 'package:craft/app/repository/chat_repository/models/message_model.dart';
import 'package:craft/app/repository/chat_repository/models/send_message_model.dart';
import 'package:craft/app/repository/chat_repository/repo/chat_repository.dart';
import 'package:craft/app/services/web_socket_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatRepo extends ChatRepository {
  final _webSocketService = WebSocketService();

  @override
  Future<void> sendMessage(String groupId, String message) async {
    final sendMessage = SendMessage(roomId: groupId, message: message);
    final packet = SendMessagePacketModel(data: sendMessage);

    _webSocketService.sendMessage(jsonEncode(packet.toJson()));
  }

  @override
  Stream<Message> getMessages() async* {
    _webSocketService.closeStream('messages');

    final stream = _webSocketService.getStream('messages');

    await for (final message in stream) {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final type = data['type'] as String;

      if (type == 'message') {
        final message = Message.fromJson(data['data'] as Map<String, dynamic>);

        yield message;
      }
    }
  }
}
