import 'package:craft/app/repository/authentication_repository/model/user_model.dart';

abstract class AuthenticationRepository {
  Future<User> login(String username);
}
