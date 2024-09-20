import 'package:craft/screens/connection/connection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@immutable
@TypedGoRoute<LoginRoute>(path: '/connection')
class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ConnectionPage();
  }
}
