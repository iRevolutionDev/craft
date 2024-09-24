part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLogin extends AuthenticationEvent {
  final String username;

  const AuthenticationLogin({
    required this.username,
  });

  @override
  List<Object?> get props => [username];
}

class AuthenticationLoggedOut extends AuthenticationEvent {}
