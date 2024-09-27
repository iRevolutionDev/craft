import 'package:craft/app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:craft/app/bloc/chat_bloc/chat_bloc.dart' as chat;
import 'package:craft/app/bloc/group_bloc/group_bloc.dart';
import 'package:craft/screens/home/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<types.TextMessage>> messages = {};
  List<String> joinedGroups = [];
  String? roomId;

  @override
  void initState() {
    super.initState();
  }

  void _onGroupTap(String owner, String uuid) {
    final state = context.read<AuthenticationBloc>().state;

    if (state is AuthenticationSuccess && state.user.id == owner) {
      setState(() {
        roomId = uuid;
      });
      return;
    }

    if (!joinedGroups.contains(uuid)) {
      context.read<GroupBloc>().add(GroupJoin(
            groupId: uuid,
          ));
    }

    setState(() {
      roomId = uuid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      onGroupTap: _onGroupTap,
      selectedGroup: roomId ?? '',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: roomId == null
            ? const [
                Text('Select a group to start chatting'),
              ]
            : [
                BlocListener<chat.ChatBloc, chat.ChatState>(
                    listener: (context, state) {
                      switch (state) {
                        case chat.ChatMessageReceivedSuccess(
                            chatMessage: final message
                          ):
                          setState(() {
                            messages[roomId]?.insert(
                                0,
                                types.TextMessage(
                                  author: types.User(
                                    id: message.user.id,
                                    firstName: message.user.name,
                                  ),
                                  id: message.id,
                                  text: message.message,
                                  createdAt:
                                      message.createdAt.millisecondsSinceEpoch,
                                ));
                          });
                          break;
                        default:
                          break;
                      }
                    },
                    child: const SizedBox()),
                BlocListener<GroupBloc, GroupState>(
                  listener: (context, state) {
                    switch (state) {
                      case GroupCreated(group: final group):
                        setState(() {
                          roomId = group.id;
                          joinedGroups.add(group.id);
                          messages[group.id] = [];
                        });
                        break;
                      case GroupJoined(group: final group):
                        setState(() {
                          joinedGroups.add(group.id);
                          messages[group.id] = group.messages
                              .map((e) => types.TextMessage(
                                    author: types.User(
                                        id: e.user.id, firstName: e.user.name),
                                    id: e.id,
                                    text: e.message,
                                    createdAt:
                                        DateTime.now().millisecondsSinceEpoch,
                                  ))
                              .toList();
                        });
                        break;
                      default:
                        break;
                    }
                  },
                  child: const SizedBox(),
                ),
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    return switch (state) {
                      AuthenticationSuccess(user: final user) => Expanded(
                          child: Chat(
                            theme: DefaultChatTheme(
                                backgroundColor: Colors.transparent,
                                inputMargin: const EdgeInsets.all(8),
                                inputBorderRadius: BorderRadius.circular(20)),
                            messages: messages[roomId] ?? [],
                            showUserAvatars: true,
                            onSendPressed: (message) {
                              context.read<chat.ChatBloc>().add(
                                    chat.ChatMessageSent(
                                      roomId: roomId ?? '',
                                      message: message.text,
                                    ),
                                  );
                            },
                            user: types.User(id: user.id),
                          ),
                        ),
                      _ => const CircularProgressIndicator(),
                    };
                  },
                ),
              ],
      ),
    );
  }
}
