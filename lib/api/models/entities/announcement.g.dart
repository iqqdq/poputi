// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
      id: json['id'] as int,
      isDeleted: json['isDeleted'] as bool?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      price: (json['price'] as num?)?.toDouble(),
      departureDttm: DateTime.parse(json['departureDttm'] as String),
      parcelWeight: (json['parcelWeight'] as num).toDouble(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      comment: json['comment'] as String,
      hasWhatsapp: json['hasWhatsapp'] as bool,
      hasTelegram: json['hasTelegram'] as bool,
      departureFrom:
          City.fromJson(json['departureFrom'] as Map<String, dynamic>),
      arrivalTo: City.fromJson(json['arrivalTo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'price': instance.price,
      'departureDttm': instance.departureDttm.toIso8601String(),
      'parcelWeight': instance.parcelWeight,
      'name': instance.name,
      'phone': instance.phone,
      'comment': instance.comment,
      'hasWhatsapp': instance.hasWhatsapp,
      'hasTelegram': instance.hasTelegram,
      'departureFrom': instance.departureFrom,
      'arrivalTo': instance.arrivalTo,
    };
