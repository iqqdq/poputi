import 'package:json_annotation/json_annotation.dart';
import 'package:poputi/api/models/models.dart';

part 'cities_response.g.dart';

@JsonSerializable()
class CitiesResponse {
  CitiesResponse({
    required this.count,
    required this.pageCount,
    this.next,
    this.previous,
    required this.results,
  });

  int count;
  int pageCount;
  String? next;
  String? previous;
  List<City> results;

  Map<String, dynamic> toJson() => _$CitiesResponseToJson(this);

  factory CitiesResponse.fromJson(Map<String, dynamic> json) =>
      _$CitiesResponseFromJson(json);
}
