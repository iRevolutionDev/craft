import 'package:craft/app/model/request_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_message_model.g.dart';

class SendMessagePacketModel extends RequestBase<SendMessage> {
  SendMessagePacketModel({required super.data})
      : super(
          type: "send",
        );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": data.toJson(),
      };
}

@JsonSerializable()
class SendMessage {
  @JsonKey(name: 'room_id')
  final String roomId;
  final String message;

  SendMessage({
    required this.roomId,
    required this.message,
  });

  factory SendMessage.fromJson(Map<String, dynamic> json) =>
      _$SendMessageFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageToJson(this);
}
