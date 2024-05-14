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

  final int id;
  final bool? isDeleted;
  final DateTime createdAt;
  final double? price;
  final DateTime departureDttm;
  final double parcelWeight;
  final String name;
  final String phone;
  final String comment;
  final bool hasWhatsapp;
  final bool hasTelegram;
  final City departureFrom;
  final City arrivalTo;

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
}
