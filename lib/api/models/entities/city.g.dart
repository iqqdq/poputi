// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      id: json['id'] as int,
      isDeleted: json['isDeleted'] as bool,
      createdAt: json['createdAt'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt,
      'name': instance.name,
    };
