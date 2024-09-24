import 'dart:convert';

import 'package:craft/app/repository/groups_repository/models/create_group_model.dart';
import 'package:craft/app/repository/groups_repository/models/group_model.dart';
import 'package:craft/app/repository/groups_repository/repo/groups_repository.dart';
import 'package:craft/app/services/web_socket_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GroupsRepo extends GroupsRepository {
  final _webSocketService = WebSocketService();

  @override
  Stream<List<Group>> getGroups() async* {
    _webSocketService.closeStream('groups');

    final stream = _webSocketService.getStream('groups');

    await for (final message in stream) {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final type = data['type'] as String;

      if (type == 'rooms') {
        final groups = (data['data'] as List)
            .map((group) => Group.fromJson(group as Map<String, dynamic>))
            .toList();

        yield groups;
      }
    }
  }

  @override
  Future<void> createGroup(CreateGroup group) {
    _webSocketService.closeStream('create_group');

    final data = jsonEncode(CreateGroupPacketModel(data: group).toJson());
    _webSocketService.sendMessage(data);

    final stream = _webSocketService.getStream('create_group');

    return stream.firstWhere((message) {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final type = data['type'] as String;

      return type == 'room_created';
    });
  }
}
