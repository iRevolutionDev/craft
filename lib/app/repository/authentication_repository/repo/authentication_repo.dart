import 'dart:convert';

import 'package:craft/app/repository/authentication_repository/model/join_model.dart';
import 'package:craft/app/repository/authentication_repository/model/join_user_model.dart';
import 'package:craft/app/repository/authentication_repository/model/user_model.dart';
import 'package:craft/app/repository/authentication_repository/repo/authentication_repository.dart';
import 'package:craft/app/services/web_socket_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthenticationRepo extends AuthenticationRepository {
  final _webSocketService = WebSocketService();

  @override
  Future<User> login(String username) async {
    final user = JoinUser(username: username);

    final joinModel = JoinModel(data: user);

    _webSocketService.sendMessage(jsonEncode(joinModel.toJson()));

    final stream = _webSocketService.getStream('login');

    await for (final response in stream.timeout(const Duration(seconds: 5))) {
      final data = jsonDecode(response.toString());

      if (data['type'] != 'joined') {
        continue;
      }

      _webSocketService.closeStream('login');
      return User.fromJson(data['data']['user'] as Map<String, dynamic>);
    }

    _webSocketService.closeStream('login');
    throw Exception('Failed to login');
  }
}
