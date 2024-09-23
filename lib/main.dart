import 'package:craft/app.dart';
import 'package:craft/app/bloc_observer.dart';
import 'package:craft/app/rust/frb_generated.dart';
import 'package:craft/di/di.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();

  configureDependencies();

  Bloc.observer = AppBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getTemporaryDirectory());

  runApp(const MyApp());
}
