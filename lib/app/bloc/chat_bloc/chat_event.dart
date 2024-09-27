part of "chat_bloc.dart";

class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatStarted extends ChatEvent {}

class ChatFetch extends ChatEvent {
  final String roomId;

  const ChatFetch({
    required this.roomId,
  });

  @override
  List<Object> get props => [roomId];
}

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
