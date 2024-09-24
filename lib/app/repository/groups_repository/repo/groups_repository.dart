import 'package:craft/app/repository/groups_repository/models/create_group_model.dart';
import 'package:craft/app/repository/groups_repository/models/group_model.dart';

abstract class GroupsRepository {
  Stream<List<Group>> getGroups();

  Future<void> createGroup(CreateGroup group);
}
