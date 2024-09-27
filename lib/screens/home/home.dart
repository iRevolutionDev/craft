import 'package:craft/app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:craft/app/bloc/chat_bloc/chat_bloc.dart' as chat;
import 'package:craft/app/bloc/group_bloc/group_bloc.dart';
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
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            SafeArea(
                child: SideMenu(
                    onGroupTap: _onGroupTap, selectedGroup: roomId ?? '')),
            Expanded(
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
                                          createdAt: message
                                              .createdAt.millisecondsSinceEpoch,
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
                                });
                                break;
                              case GroupJoined(group: final group):
                                setState(() {
                                  joinedGroups.add(group.id);
                                  messages[group.id] = group.messages
                                      .map((e) => types.TextMessage(
                                            author: types.User(
                                                id: e.user.id,
                                                firstName: e.user.name),
                                            id: e.id,
                                            text: e.message,
                                            createdAt: DateTime.now()
                                                .millisecondsSinceEpoch,
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
                              AuthenticationSuccess(user: final user) =>
                                Expanded(
                                  child: Chat(
                                    theme: DefaultChatTheme(
                                        backgroundColor: Colors.transparent,
                                        inputMargin: const EdgeInsets.all(8),
                                        inputBorderRadius:
                                            BorderRadius.circular(20)),
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
            ),
          ],
        ),
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  final String selectedGroup;
  final void Function(String owner, String uuid) onGroupTap;

  const SideMenu(
      {super.key, required this.onGroupTap, required this.selectedGroup});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
        return Column(
          children: [
            switch (state) {
              GroupLoaded(groups: final groups) => Expanded(
                    child: ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(group.name[0]),
                      ),
                      selected: selectedGroup == group.id,
                      selectedTileColor: Theme.of(context).primaryColor,
                      title: Text(group.name),
                      onTap: () => onGroupTap(group.owner, group.id),
                    );
                  },
                )),
              _ => const CircularProgressIndicator(),
            },
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () => _showAddGroupDialog(context),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showAddGroupDialog(BuildContext context) {
    final TextEditingController groupNameController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add group'),
          content: TextField(
            controller: groupNameController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Group name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final groupName = groupNameController.text;
                if (groupName.isNotEmpty) {
                  context.read<GroupBloc>().add(GroupCreate(
                        name: groupName,
                      ));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
