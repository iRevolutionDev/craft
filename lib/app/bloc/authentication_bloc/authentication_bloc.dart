import 'package:bloc/bloc.dart';
import 'package:craft/app/repository/authentication_repository/model/user_model.dart';
import 'package:craft/app/repository/authentication_repository/repo/authentication_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this._authenticationRepository)
      : super(AuthenticationInitial()) {
    on<AuthenticationLogin>(_onLogin);
  }

  final AuthenticationRepo _authenticationRepository;
  final Logger _logger = Logger('AuthenticationBloc');

  Future<void> _onLogin(
    AuthenticationLogin event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      _logger.info('Logging in as ${event.username}...');

      emit(AuthenticationLoading());

      final user = await _authenticationRepository.login(event.username);

      emit(AuthenticationSuccess(user));
    } catch (e) {
      _logger.severe('Failed to login: $e');
      emit(AuthenticationFailure(e.toString()));
    }
  }
}
