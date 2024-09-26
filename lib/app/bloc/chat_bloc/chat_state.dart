part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatMessageReceivedSuccess extends ChatState {
  final Message chatMessage;

  const ChatMessageReceivedSuccess(this.chatMessage);

  @override
  List<Object> get props => [chatMessage];
}

class ChatMessageLoadSuccess extends ChatState {
  final Message chatMessage;

  const ChatMessageLoadSuccess(this.chatMessage);

  @override
  List<Object> get props => [chatMessage];
}

class ChatError extends ChatState {
  final String message;

  const ChatError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class ChatMessageSentSuccess extends ChatState {}
