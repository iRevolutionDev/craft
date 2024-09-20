import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class AppBlocObserver extends BlocObserver {
  final Logger _logger = Logger('AppBlocObserver');

  @override
  void onEvent(final bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.info('onEvent: bloc: $bloc, event: $event');
  }

  @override
  void onError(final bloc, Object error, StackTrace stackTrace) {
    _logger
        .severe('onError: bloc: $bloc, error: $error, stackTrace: $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(final bloc, final change) {
    _logger.info('onChange: bloc: $bloc, change: $change');
    super.onChange(bloc, change);
  }

  @override
  void onTransition(final bloc, final transition) {
    _logger.info('onTransition: bloc: $bloc, transition: $transition');
    super.onTransition(bloc, transition);
  }
}
