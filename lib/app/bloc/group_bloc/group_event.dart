part of 'group_bloc.dart';

class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class GroupStarted extends GroupEvent {}

class GroupLoad extends GroupEvent {}

class GroupSelected extends GroupEvent {
  final String groupId;

  const GroupSelected({
    required this.groupId,
  });

  @override
  List<Object> get props => [groupId];
}

class GroupCreate extends GroupEvent {
  final String name;
  final String? password;

  const GroupCreate({
    required this.name,
    this.password,
  });

  @override
  List<Object> get props => [name, password ?? ''];
}

class GroupJoin extends GroupEvent {
  final String groupId;
  final String? password;

  const GroupJoin({
    required this.groupId,
    this.password,
  });

  @override
  List<Object> get props => [groupId, password ?? ''];
}

class GroupLeave extends GroupEvent {
  final String groupId;

  const GroupLeave({
    required this.groupId,
  });

  @override
  List<Object> get props => [groupId];
}

class GroupSendMessage extends GroupEvent {
  final String groupId;
  final String message;

  const GroupSendMessage({
    required this.groupId,
    required this.message,
  });

  @override
  List<Object> get props => [groupId, message];
}
