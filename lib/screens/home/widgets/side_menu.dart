import 'package:craft/app/bloc/chat_bloc/chat_bloc.dart';
import 'package:craft/app/bloc/group_bloc/group_bloc.dart';
import 'package:craft/responsive/breakpoint_container.dart';
import 'package:craft/responsive/breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideMenu extends StatefulWidget {
  final String selectedGroup;
  final Widget child;
  final void Function(String owner, String uuid) onGroupTap;

  const SideMenu(
      {super.key,
      required this.onGroupTap,
      required this.selectedGroup,
      required this.child});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final Map<String, String> lastMessages = {};

  @override
  Widget build(BuildContext context) {
    final isMd = BreakPoint.of(context).isSmallerThan(BreakpointID.md);

    return Scaffold(
      body: BreakpointContainer(
        mdChild: Row(
          children: [
            _buildSideMenu(context),
            Expanded(
                child: Scaffold(
                    appBar: _buildAppBar(context), body: widget.child)),
          ],
        ),
        child: Scaffold(
          appBar: _buildAppBar(context),
          drawer: isMd ? _buildSideMenu(context) : null,
          body: widget.child,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).drawerTheme.surfaceTintColor,
      scrolledUnderElevation: 0,
      title: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          return switch (state) {
            GroupLoaded(groups: final groups) => Row(
                children: groups.isNotEmpty && widget.selectedGroup.isNotEmpty
                    ? [
                        CircleAvatar(
                            child: Text(groups
                                .firstWhere(
                                    (group) => group.id == widget.selectedGroup,
                                    orElse: () => groups.first)
                                .name[0]
                                .toUpperCase())),
                        const SizedBox(width: 8),
                        Text(groups
                            .firstWhere(
                                (group) => group.id == widget.selectedGroup,
                                orElse: () => groups.first)
                            .name),
                      ]
                    : []),
            _ => const CircularProgressIndicator(),
          };
        },
      ),
    );
  }

  Widget _buildSideMenu(BuildContext context) {
    final isMd = BreakPoint.of(context).isSmallerThan(BreakpointID.md);

    return Drawer(
      width: isMd ? null : 400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(isMd ? 16 : 0),
          bottomRight: const Radius.circular(16),
        ),
      ),
      child: BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
        return switch (state) {
          GroupLoaded(groups: final groups) => Column(
              children: [
                DrawerHeader(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('Groups',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24)),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilledButton.icon(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () => _showAddGroupDialog(context),
                                icon: const Icon(
                                  Icons.add,
                                ),
                                label: const Text('Add group',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24)),
                          hintText: 'Search',
                          prefixIcon: const Icon(Icons.search),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hoverColor:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            leading: CircleAvatar(
                              child: Text(group.name[0].toUpperCase()),
                            ),
                            selected: widget.selectedGroup == group.id,
                            selectedTileColor: Theme.of(context).primaryColor,
                            title: Text(group.name),
                            subtitle: BlocListener<ChatBloc, ChatState>(
                                listener: (context, state) {
                                  switch (state) {
                                    case ChatMessageReceivedSuccess(
                                        chatMessage: final message
                                      ):
                                      if (message.roomId == group.id) {
                                        setState(() {
                                          lastMessages[group.id] =
                                              message.message;
                                        });
                                      }
                                      break;
                                  }
                                },
                                child: Text(
                                  lastMessages[group.id]?.isNotEmpty ?? false
                                      ? lastMessages[group.id] ?? 'No messages'
                                      : group.messages.isNotEmpty
                                          ? group.messages.last.message
                                          : 'No messages',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                            onTap: () => {
                                  widget.onGroupTap(group.owner, group.id),
                                  //close the drawer on mobile
                                  if (isMd) Navigator.of(context).pop(),
                                }),
                      );
                    },
                  ),
                ),
              ],
            ),
          _ => const Center(child: CircularProgressIndicator()),
        };
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
