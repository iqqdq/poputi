import 'package:poputi/entities/response/announcement_model.dart';

class Announcements {
  Announcements({
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
  List<Announcement> results;

  factory Announcements.fromJson(Map<String, dynamic> json) => Announcements(
        count: json["count"],
        pageCount: json["pageCount"],
        next: json["next"],
        previous: json["previous"],
        results: List<Announcement>.from(
            json["results"].map((x) => Announcement.fromJson(x))),
      );
}
