// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: always_specify_types, public_member_api_docs

part of 'create_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGroup _$CreateGroupFromJson(Map<String, dynamic> json) => CreateGroup(
      name: json['name'] as String,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$CreateGroupToJson(CreateGroup instance) =>
    <String, dynamic>{
      'name': instance.name,
      'password': instance.password,
    };
