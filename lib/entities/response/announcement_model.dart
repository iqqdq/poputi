import 'package:poputi/entities/response/city_model.dart';

class Announcement {
  Announcement({
    required this.id,
    this.isDeleted,
    this.createdAt,
    this.price,
    required this.departureDttm,
    required this.arrivalDttm,
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
  String? createdAt;
  double? price;
  String departureDttm;
  String arrivalDttm;
  double parcelWeight;
  String name;
  String phone;
  String comment;
  bool hasWhatsapp;
  bool hasTelegram;
  City departureFrom;
  City arrivalTo;

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        id: json["id"],
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"],
        departureDttm: json["departureDttm"],
        arrivalDttm: json["arrivalDttm"],
        parcelWeight: json["parcelWeight"],
        price: json["price"],
        name: json["name"],
        phone: json["phone"],
        comment: json["comment"],
        hasWhatsapp: json["hasWhatsapp"],
        hasTelegram: json["hasTelegram"] ?? false,
        departureFrom: City.fromJson(json["departureFrom"]),
        arrivalTo: City.fromJson(json["arrivalTo"]),
      );
}
