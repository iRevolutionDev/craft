import 'package:craft/app/models/json_serializeble.dart';
import 'package:flutter/material.dart';

@immutable
class JoinUser extends JsonSerializable {
  final String username;

  JoinUser({
    required this.username,
  });

  @override
  JoinUser fromJson(Map<String, dynamic> json) {
    return JoinUser(
      username: json['username'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'username': username,
    };
  }
}
