import 'package:craft/app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:craft/app/bloc/group_bloc/group_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            const SafeArea(child: SideMenu()),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      return switch (state) {
                        AuthenticationSuccess(user: final user) => Expanded(
                            child: Chat(
                              messages: [
                                types.TextMessage(
                                    author: types.User(id: user.id),
                                    id: '1',
                                    text:
                                        'Affs não aguento mais socorro 😔✊🏻'),
                              ],
                              user: types.User(id: user.id),
                              onSendPressed: (message) {
                                // Handle send message
                              },
                            ),
                          ),
                        _ => const Text('Loading...'),
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
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: switch (state) {
                GroupLoaded(groups: final groups) => ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      return ListTile(
                        title: Text(group.name),
                        onTap: () {
                          // Handle group tap
                        },
                      );
                    },
                  ),
                _ => const Text('Loading...'),
              },
            ),
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
    final TextEditingController _groupNameController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add group'),
          content: TextField(
            controller: _groupNameController,
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
                final groupName = _groupNameController.text;
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
