import 'package:craft/app/models/packet_base.dart';
import 'package:craft/app/repository/authentication_repository/model/join_user_model.dart';
import 'package:flutter/material.dart';

@immutable
class JoinModel extends PacketBase<JoinUser> {
  const JoinModel({
    required JoinUser user,
  }) : super(type: 'join', data: user);
}
