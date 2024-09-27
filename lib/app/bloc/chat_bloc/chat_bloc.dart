import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:craft/app/repository/chat_repository/models/message_model.dart';
import 'package:craft/app/repository/chat_repository/repo/chat_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<ChatFetch>(_onChatFetch);
    on<ChatStarted>(_onChatStarted);
    on<ChatMessageSent>(_onChatMessageSent);
  }

  final ChatRepo chatRepository;

  void _onChatStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final messages = chatRepository.getMessagesStream();
      await for (final message in messages) {
        emit(ChatMessageReceivedSuccess(message));
      }
    } catch (e) {
      emit(ChatError(message: e.toString()));
      rethrow;
    }
  }

  void _onChatMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      await chatRepository.sendMessage(
        event.roomId,
        event.message,
      );
      emit(ChatMessageSentSuccess());
    } catch (e) {
      emit(ChatError(message: e.toString()));
      rethrow;
    }
  }

  Future<void> _onChatFetch(ChatFetch event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await chatRepository.getMessages(event.roomId);
      for (final message in messages) {
        emit(ChatMessageLoadSuccess(message));
      }
    } catch (e) {
      emit(ChatError(message: e.toString()));
      rethrow;
    }
  }
}
