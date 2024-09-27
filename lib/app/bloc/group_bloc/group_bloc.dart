import 'package:bloc/bloc.dart';
import 'package:craft/app/repository/groups_repository/models/create_group_model.dart';
import 'package:craft/app/repository/groups_repository/models/group_model.dart';
import 'package:craft/app/repository/groups_repository/repo/groups_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'group_event.dart';
part 'group_state.dart';

@injectable
class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc(
    this._groupRepository,
  ) : super(GroupInitial()) {
    on<GroupLoad>(_onGroupLoaded);
    on<GroupCreate>(_onGroupCreate);
    on<GroupJoin>(_onGroupJoin);
  }

  final GroupsRepo _groupRepository;

  void _onGroupLoaded(
    GroupLoad event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      final groups = _groupRepository.getGroupsStream();

      await for (final group in groups) {
        emit(GroupLoaded(groups: group));
      }
    } catch (e) {
      emit(GroupError(message: e.toString()));
      rethrow;
    }
  }

  void _onGroupCreate(
    GroupCreate event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      final group = await _groupRepository
          .createGroup(CreateGroup(name: event.name, password: event.password));
      emit(GroupCreated(group: group));
    } catch (e) {
      emit(GroupError(message: e.toString()));
      rethrow;
    }
  }

  void _onGroupJoin(
    GroupJoin event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      final group = await _groupRepository.joinGroup(event.groupId);
      emit(GroupJoined(group: group));

      add(GroupLoad());
    } catch (e) {
      emit(GroupError(message: e.toString()));
      rethrow;
    }
  }

  @override
  Future<void> close() {
    _groupRepository.close();
    return super.close();
  }
}
