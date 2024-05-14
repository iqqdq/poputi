import 'package:json_annotation/json_annotation.dart';

part 'announcement_request.g.dart';

@JsonSerializable()
class AnnouncementRequest {
  AnnouncementRequest({
    required this.parcelWeight,
    required this.price,
    required this.name,
    required this.phone,
    required this.comment,
    required this.hasWhatsapp,
    required this.hasTelegram,
    required this.departureFrom,
    required this.arrivalTo,
    required this.departureDttm,
  });

  final double parcelWeight;
  final double price;
  final String name;
  final String phone;
  final String comment;
  final bool hasWhatsapp;
  final bool hasTelegram;
  final int departureFrom;
  final int arrivalTo;
  final DateTime departureDttm;

  Map<String, dynamic> toJson() => _$AnnouncementRequestToJson(this);

  factory AnnouncementRequest.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementRequestFromJson(json);
}
