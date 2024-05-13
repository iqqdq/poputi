import 'package:json_annotation/json_annotation.dart';
import 'package:poputi/api/models/entities/entities.dart';

part 'announcement.g.dart';

@JsonSerializable()
class Announcement {
  Announcement({
    required this.id,
    this.isDeleted,
    required this.createdAt,
    this.price,
    required this.departureDttm,
    required this.parcelWeight,
    required this.name,
    required this.phone,
    required this.comment,
    required this.hasWhatsapp,
    required this.hasTelegram,
    required this.departureFrom,
    required this.arrivalTo,
  });

  int id;
  bool? isDeleted;
  DateTime createdAt;
  double? price;
  DateTime departureDttm;
  double parcelWeight;
  String name;
  String phone;
  String comment;
  bool hasWhatsapp;
  bool hasTelegram;
  City departureFrom;
  City arrivalTo;

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
}
