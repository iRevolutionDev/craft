import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'getit.dart';
import 'injectable.config.dart';

@injectableInit
GetIt configureDependencies() => getIt.init();
