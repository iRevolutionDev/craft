import 'package:craft/app/model/request_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_group_model.g.dart';

class CreateGroupPacketModel extends RequestBase<CreateGroup> {
  CreateGroupPacketModel({required super.data})
      : super(
          type: "create_room",
        );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": data.toJson(),
      };
}

@JsonSerializable()
class CreateGroup {
  final String name;
  final String? password;

  CreateGroup({
    required this.name,
    this.password,
  });

  factory CreateGroup.fromJson(Map<String, dynamic> json) =>
      _$CreateGroupFromJson(json);

  Map<String, dynamic> toJson() => _$CreateGroupToJson(this);
}
