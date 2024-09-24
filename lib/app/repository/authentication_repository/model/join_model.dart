import 'package:craft/app/model/request_base.dart';
import 'package:craft/app/repository/authentication_repository/model/join_user_model.dart';

class JoinModel extends RequestBase<JoinUser> {
  JoinModel({
    required super.data,
  }) : super(
          type: 'join',
        );

  Map<String, dynamic> toJson() => {'type': type, 'data': data.toJson()};
}
