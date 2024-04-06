import 'dart:convert';

class AnnouncementRequest {
  AnnouncementRequest({
    required this.departureDttm,
    required this.arrivalDttm,
    required this.parcelWeight,
    this.price,
    required this.name,
    required this.phone,
    required this.comment,
    required this.hasWhatsapp,
    required this.hasTelegram,
    required this.departureFrom,
    required this.arrivalTo,
  });

  String departureDttm;
  String arrivalDttm;
  double parcelWeight;
  double? price;
  String name;
  String phone;
  String comment;
  bool hasWhatsapp;
  bool hasTelegram;
  int departureFrom;
  int arrivalTo;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "departureDttm": departureDttm,
        "arrivalDttm": arrivalDttm,
        "parcelWeight": parcelWeight,
        "price": price,
        "name": name,
        "phone": phone,
        "comment": comment,
        "hasWhatsapp": hasWhatsapp,
        "hasTelegram": hasTelegram,
        "departureFrom": departureFrom,
        "arrivalTo": arrivalTo,
      };
}
