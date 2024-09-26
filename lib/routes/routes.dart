import 'dart:async';

import 'package:craft/app/bloc/connection_bloc/connection_bloc.dart';
import 'package:craft/screens/authentication/authentication.dart';
import 'package:craft/screens/connection/connection.dart';
import 'package:craft/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'routes.g.dart';

@immutable
@TypedGoRoute<ConnectionRoute>(path: '/connection')
class ConnectionRoute extends GoRouteData {
  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final prefs = await SharedPreferences.getInstance();

    final ip = prefs.getString('ip');
    final port = prefs.getInt('port');
    final alwaysConnect = prefs.getBool('alwaysConnect');

    if (ip != null && port != null && alwaysConnect != null) {
      context.read<ConnectionBloc>().add(ConnectToServer(
            ip: ip,
            port: port,
            alwaysConnect: alwaysConnect,
          ));

      return '/authentication';
    }

    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ConnectionPage();
  }
}

@immutable
@TypedGoRoute<AuthenticationRoute>(path: '/authentication')
class AuthenticationRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AuthenticationPage();
  }
}

@immutable
@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return HomeScreen();
  }
}
