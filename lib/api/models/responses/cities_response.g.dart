// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cities_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CitiesResponse _$CitiesResponseFromJson(Map<String, dynamic> json) =>
    CitiesResponse(
      count: json['count'] as int,
      pageCount: json['pageCount'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CitiesResponseToJson(CitiesResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'pageCount': instance.pageCount,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
