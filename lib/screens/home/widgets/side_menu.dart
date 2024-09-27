import 'package:craft/app/bloc/group_bloc/group_bloc.dart';
import 'package:craft/responsive/breakpoint_container.dart';
import 'package:craft/responsive/breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideMenu extends StatelessWidget {
  final String selectedGroup;
  final Widget child;
  final void Function(String owner, String uuid) onGroupTap;

  const SideMenu(
      {super.key,
      required this.onGroupTap,
      required this.selectedGroup,
      required this.child});

  @override
  Widget build(BuildContext context) {
    final isSm = BreakPoint.of(context).isSmallerThan(BreakpointID.md);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Craft'),
      ),
      drawer: isSm ? _buildSideMenu(context) : null,
      body: BreakpointContainer(
        mdChild: Row(
          children: [
            _buildSideMenu(context),
            Expanded(child: child),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildSideMenu(BuildContext context) {
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
                        child: Text(group.name[0].toUpperCase()),
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
