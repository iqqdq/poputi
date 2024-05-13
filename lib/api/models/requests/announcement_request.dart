import 'package:json_annotation/json_annotation.dart';

part 'announcement_request.g.dart';

@JsonSerializable()
class AnnouncementRequest {
  AnnouncementRequest({
    required this.parcelWeight,
    this.price,
    required this.name,
    required this.phone,
    required this.comment,
    required this.hasWhatsapp,
    required this.hasTelegram,
    required this.departureFrom,
    required this.arrivalTo,
    required this.departureDttm,
  });

  double parcelWeight;
  double? price;
  String name;
  String phone;
  String comment;
  bool hasWhatsapp;
  bool hasTelegram;
  int departureFrom;
  int arrivalTo;
  DateTime departureDttm;

  Map<String, dynamic> toJson() => _$AnnouncementRequestToJson(this);

  factory AnnouncementRequest.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementRequestFromJson(json);
}
