abstract class JsonSerializable {
  Map<String, dynamic> toJson();

  JsonSerializable fromJson(Map<String, dynamic> json);
}
