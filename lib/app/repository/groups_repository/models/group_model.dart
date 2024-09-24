import 'package:craft/app/repository/chat_repository/models/message_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_model.g.dart';

@JsonSerializable()
class Group {
  final String id;
  final String name;
  final String? password;
  final String owner;
  final List<String> users;
  final List<Message> messages;

  Group({
    required this.id,
    required this.name,
    this.password,
    required this.owner,
    required this.users,
    required this.messages,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
