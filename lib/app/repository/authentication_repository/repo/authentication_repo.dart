import 'dart:convert';

import 'package:craft/app/repository/authentication_repository/model/join_model.dart';
import 'package:craft/app/repository/authentication_repository/model/join_user_model.dart';
import 'package:craft/app/repository/authentication_repository/model/user_model.dart';
import 'package:craft/app/repository/authentication_repository/repo/authentication_repository.dart';
import 'package:craft/app/services/web_socket_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthenticationRepo extends AuthenticationRepository {
  final WebSocketService _webSocketService = WebSocketService.instance();

  @override
  Future<User> login(String username) async {
    final user = JoinUser(username: username);

    _webSocketService.sendMessage(JoinModel(user: user).toJson());

    await for (final response
        in _webSocketService.stream.timeout(const Duration(seconds: 5))) {
      final data = jsonDecode(response.toString());

      if (data['type'] == 'joined') {
        return User.fromJson(data as Map<String, dynamic>);
      }
    }

    throw Exception('Failed to login');
  }
}
