import 'package:equatable/equatable.dart';

abstract class ConnectionBlocState extends Equatable {
  const ConnectionBlocState();

  @override
  List<Object?> get props => [];
}

class ConnectionInitial extends ConnectionBlocState {}

class ConnectionLoading extends ConnectionBlocState {}

class ConnectionSuccess extends ConnectionBlocState {}

class ConnectionFailure extends ConnectionBlocState {
  final String error;

  const ConnectionFailure(this.error);

  @override
  List<Object?> get props => [error];
}
