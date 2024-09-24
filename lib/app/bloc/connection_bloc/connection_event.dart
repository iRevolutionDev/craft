part of 'connection_bloc.dart';

abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object?> get props => [];
}

class ConnectToServer extends ConnectionEvent {
  final String ip;
  final int port;
  final bool alwaysConnect;

  const ConnectToServer({
    required this.ip,
    required this.port,
    required this.alwaysConnect,
  });

  @override
  List<Object?> get props => [ip, port];
}

class DisconnectFromServer extends ConnectionEvent {}

class ReconnectToServer extends ConnectionEvent {}
