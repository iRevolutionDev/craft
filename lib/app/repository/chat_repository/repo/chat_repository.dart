import 'package:craft/app/repository/chat_repository/models/message_model.dart';

abstract class ChatRepository {
  Future<void> sendMessage(String groupId, String message);

  Stream<Message> getMessages();
}
