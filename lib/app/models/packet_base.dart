import 'dart:convert';

import 'package:craft/app/models/json_serializeble.dart';

class PacketBase<T extends JsonSerializable> {
  final String type;
  final T data;

  const PacketBase({
    required this.type,
    required this.data,
  });

  String toJson() {
    return '{"type":"$type","data":${jsonEncode(data.toJson())}}';
  }

  PacketBase<T> fromJson(Map<String, dynamic> json) {
    return PacketBase(
      type: json['type'] as String,
      data: data.fromJson(json['data'] as Map<String, dynamic>) as T,
    );
  }

  @override
  String toString() {
    return 'PacketBase(type: $type, data: $data)';
  }
}
