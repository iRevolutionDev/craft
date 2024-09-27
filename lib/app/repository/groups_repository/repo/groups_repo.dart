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
  Future<List<Group>> getGroups() {
    _webSocketService.closeStream('groups');

    final data = jsonEncode({'type': 'get_rooms'});
    _webSocketService.sendMessage(data);

    final stream = _webSocketService.getStream('groups');

    return stream.firstWhere((message) {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final type = data['type'] as String;

      return type == 'rooms';
    }).then((message) {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final groups = (data['data'] as List)
          .map((group) => Group.fromJson(group as Map<String, dynamic>))
          .toList();

      return groups;
    });
  }

  @override
  Stream<List<Group>> getGroupsStream() async* {
    _webSocketService.closeStream('groups');

    final data = jsonEncode({'type': 'get_rooms'});
    _webSocketService.sendMessage(data);

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
  Future<Group> createGroup(CreateGroup group) {
    _webSocketService.closeStream('create_group');

    final data = jsonEncode(CreateGroupPacketModel(data: group).toJson());
    _webSocketService.sendMessage(data);

    final stream = _webSocketService.getStream('create_group');

    return stream.firstWhere((message) {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final type = data['type'] as String;

      return type == 'room_created';
    }).then((message) {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final room = data['data'] as Map<String, dynamic>;

      if (room.isEmpty) {
        throw Exception('Room not found');
      }

      if (room['error'] != null) {
        throw Exception(room['error']);
      }

      return Group.fromJson(room);
    });
  }

  @override
  Future<Group> joinGroup(String groupId) {
    _webSocketService.closeStream('join_group');

    final data = jsonEncode({
      'type': 'join_room',
      'data': groupId,
    });
    _webSocketService.sendMessage(data);

    final stream = _webSocketService.getStream('join_group');

    return stream.firstWhere((message) {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final type = data['type'] as String;

      return type == 'joined_room';
    }).then((message) {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final room = data['data'] as Map<String, dynamic>;

      if (room.isEmpty) {
        throw Exception('Room not found');
      }

      if (room['error'] != null) {
        throw Exception(room['error']);
      }

      return Group.fromJson(room);
    });
  }

  @override
  void close() {
    _webSocketService.closeStream('groups');
    _webSocketService.closeStream('create_group');
    _webSocketService.closeStream('join_group');
  }
}
