part of "chat_bloc.dart";

class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatStarted extends ChatEvent {}

class ChatMessageSent extends ChatEvent {
  final String roomId;
  final String message;

  const ChatMessageSent({
    required this.roomId,
    required this.message,
  });

  @override
  List<Object> get props => [roomId, message];
}
