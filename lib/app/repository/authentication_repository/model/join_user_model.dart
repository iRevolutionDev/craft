import 'package:json_annotation/json_annotation.dart';

part 'join_user_model.g.dart';

@JsonSerializable()
class JoinUser {
  final String username;

  JoinUser({
    required this.username,
  });

  factory JoinUser.fromJson(Map<String, dynamic> json) =>
      _$JoinUserFromJson(json);

  Map<String, dynamic> toJson() => _$JoinUserToJson(this);
}
