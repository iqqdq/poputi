import 'package:poputi/entities/response/city_model.dart';

class Cities {
  Cities({
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

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
        count: json["count"],
        pageCount: json["pageCount"],
        next: json["next"],
        previous: json["previous"],
        results: List<City>.from(json["results"].map((x) => City.fromJson(x))),
      );
}
