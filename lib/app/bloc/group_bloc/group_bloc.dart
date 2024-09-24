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
  }

  final GroupsRepo _groupRepository;

  void _onGroupLoaded(
    GroupLoad event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      final groups = _groupRepository.getGroups();
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
      await _groupRepository
          .createGroup(CreateGroup(name: event.name, password: event.password));
      emit(GroupCreated());
    } catch (e) {
      emit(GroupError(message: e.toString()));
      rethrow;
    }
  }
}
