import 'package:craft/app/repository/authentication_repository/model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class Message {
  final String id;
  final User user;
  @JsonKey(name: 'room_id')
  final String roomId;
  final String message;

  // @JsonKey(name: 'created_at')
  // final DateTime createdAt;

  Message({
    required this.id,
    required this.user,
    required this.roomId,
    required this.message,
    // required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
