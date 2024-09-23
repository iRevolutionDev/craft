import 'package:craft/app/repository/authentication_repository/model/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  const AuthenticationSuccess(this.user);

  final User user;

  @override
  List<Object?> get props => [];
}

class AuthenticationFailure extends AuthenticationState {
  final String error;

  const AuthenticationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
