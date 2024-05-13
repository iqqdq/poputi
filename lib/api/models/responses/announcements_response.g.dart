// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcements_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementsResponse _$AnnouncementsResponseFromJson(
        Map<String, dynamic> json) =>
    AnnouncementsResponse(
      count: json['count'] as int,
      pageCount: json['pageCount'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => Announcement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnnouncementsResponseToJson(
        AnnouncementsResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'pageCount': instance.pageCount,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
