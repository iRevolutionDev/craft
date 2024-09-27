import 'package:craft/app/repository/groups_repository/models/create_group_model.dart';
import 'package:craft/app/repository/groups_repository/models/group_model.dart';

abstract class GroupsRepository {
  Future<List<Group>> getGroups();

  Stream<List<Group>> getGroupsStream();

  Future<Group> createGroup(CreateGroup group);

  Future<Group> joinGroup(String groupId);

  void close();
}
