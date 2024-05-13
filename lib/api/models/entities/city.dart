import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

@JsonSerializable()
class City {
  City({
    required this.id,
    required this.isDeleted,
    required this.createdAt,
    required this.name,
  });

  int id;
  bool isDeleted;
  String createdAt;
  String name;

  Map<String, dynamic> toJson() => _$CityToJson(this);

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}
