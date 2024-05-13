// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementRequest _$AnnouncementRequestFromJson(Map<String, dynamic> json) =>
    AnnouncementRequest(
      parcelWeight: (json['parcelWeight'] as num).toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      comment: json['comment'] as String,
      hasWhatsapp: json['hasWhatsapp'] as bool,
      hasTelegram: json['hasTelegram'] as bool,
      departureFrom: json['departureFrom'] as int,
      arrivalTo: json['arrivalTo'] as int,
      departureDttm: DateTime.parse(json['departureDttm'] as String),
    );

Map<String, dynamic> _$AnnouncementRequestToJson(
        AnnouncementRequest instance) =>
    <String, dynamic>{
      'parcelWeight': instance.parcelWeight,
      'price': instance.price,
      'name': instance.name,
      'phone': instance.phone,
      'comment': instance.comment,
      'hasWhatsapp': instance.hasWhatsapp,
      'hasTelegram': instance.hasTelegram,
      'departureFrom': instance.departureFrom,
      'arrivalTo': instance.arrivalTo,
      'departureDttm': instance.departureDttm.toIso8601String(),
    };
