part of 'group_bloc.dart';

class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object> get props => [];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final List<Group> groups;

  const GroupLoaded({
    required this.groups,
  });

  @override
  List<Object> get props => [groups];
}

class GroupCreated extends GroupState {}

class GroupError extends GroupState {
  final String message;

  const GroupError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class GroupJoined extends GroupState {
  final Group group;

  const GroupJoined({
    required this.group,
  });

  @override
  List<Object> get props => [group];
}
