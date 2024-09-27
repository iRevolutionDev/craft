// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: always_specify_types, public_member_api_docs

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      roomId: json['room_id'] as String,
      message: json['message'] as String,
      createdAt: Message._dateTimeFromTimestamp(json['created_at'] as String?),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'room_id': instance.roomId,
      'message': instance.message,
      'created_at': Message._dateTimeToTimestamp(instance.createdAt),
    };
