import 'package:bloc/bloc.dart';
import 'package:craft/app/repository/connection_repository/repo/connection_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

part 'connection_event.dart';
part 'connection_state.dart';

@injectable
class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionBlocState> {
  ConnectionBloc(this._connectionRepository) : super(ConnectionInitial()) {
    on<ConnectToServer>(_onConnectToServer);
  }

  final Logger _logger = Logger('ConnectionBloc');
  final ConnectionRepository _connectionRepository;

  Future<void> _onConnectToServer(
      ConnectToServer event, Emitter<ConnectionBlocState> emit) async {
    try {
      emit(ConnectionLoading());

      _logger.info('Connecting to server at ${event.ip}:${event.port}...');

      await _connectionRepository.connect(
          event.ip, event.port, event.alwaysConnect);

      emit(ConnectionSuccess());
    } catch (e) {
      emit(ConnectionFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _connectionRepository.disconnect();
    return super.close();
  }
}
