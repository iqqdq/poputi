import 'package:json_annotation/json_annotation.dart';
import 'package:poputi/api/models/entities/announcement.dart';

part 'announcements_response.g.dart';

@JsonSerializable()
class AnnouncementsResponse {
  AnnouncementsResponse({
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

  Map<String, dynamic> toJson() => _$AnnouncementsResponseToJson(this);

  factory AnnouncementsResponse.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementsResponseFromJson(json);
}