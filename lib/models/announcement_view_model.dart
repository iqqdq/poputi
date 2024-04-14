import 'package:flutter/material.dart';
import 'package:poputi/entities/request/announcement_request_model.dart';
import 'package:poputi/entities/response/announcement_model.dart';
import 'package:poputi/entities/response/city_model.dart';
import 'package:poputi/repositories/announcements_repository.dart';
import 'package:poputi/services/loading_status.dart';

class AnnouncementViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  bool emptyRequiredFileds = false;
  String? error;
  Announcement? _announcement;
  City? _fromCity;
  City? _toCity;
  DateTime? _fromDateTime;
  DateTime? _toDateTime;
  DateTime _fromTime = DateTime.now();
  DateTime _toTime = DateTime.now().add(const Duration(hours: 1));
  double _weight = 5.0;
  bool _whatsAppSwitchValue = false;
  bool _telegramAppSwitchValue = false;

  Announcement? get announcement => _announcement;

  City? get fromCity => _fromCity;

  City? get toCity => _toCity;

  DateTime? get toDateTime => _toDateTime;

  DateTime? get fromDateTime => _fromDateTime;

  DateTime get toTime => _toTime;

  DateTime get fromTime => _fromTime;

  bool get whatsAppSwitchValue => _whatsAppSwitchValue;

  double get weight => _weight;

  bool get telegramAppSwitchValue => _telegramAppSwitchValue;

  // MARK: -
  // MARK: - API CALL

  Future createAnnouncement(
    double? price, {
    required String name,
    required String phone,
    required String comment,
  }) async {
    if (_fromCity != null &&
        _toCity != null &&
        _toDateTime != null &&
        _fromDateTime != null &&
        name.isNotEmpty) {
      if (phone.replaceAll(RegExp(r'[^0-9]'), '').length >= 11) {
        loadingStatus = LoadingStatus.searching;
        emptyRequiredFileds = false;
        notifyListeners();

        DateTime from = DateTime(
          _fromDateTime!.year,
          _fromDateTime!.month,
          _fromDateTime!.day,
          _fromTime.hour,
          _fromTime.minute,
        );

        String fromIso = DateTime.fromMillisecondsSinceEpoch(
          from.millisecondsSinceEpoch,
          isUtc: false,
        ).toIso8601String();

        DateTime to = DateTime(
          _toDateTime!.year,
          _toDateTime!.month,
          _toDateTime!.day,
          _toTime.hour,
          _toTime.minute,
        );

        String toIso = DateTime.fromMillisecondsSinceEpoch(
          to.millisecondsSinceEpoch,
          isUtc: false,
        ).toIso8601String();

        await AnnouncementsRepository()
            .sendAnnouncement(AnnouncementRequest(
              departureDttm: fromIso,
              arrivalDttm: toIso,
              parcelWeight: _weight,
              price: price,
              name: name,
              phone: phone.contains('+')
                  ? '+${phone.replaceAll(RegExp(r'[^0-9]'), '')}'
                  : phone.replaceAll(RegExp(r'[^0-9]'), ''),
              comment: comment,
              hasWhatsapp: _whatsAppSwitchValue,
              hasTelegram: _telegramAppSwitchValue,
              departureFrom: _fromCity!.id,
              arrivalTo: _toCity!.id,
            ))
            .then((response) => {
                  if (response is Announcement)
                    {
                      _announcement = response,
                      loadingStatus = LoadingStatus.completed
                    }
                  else
                    {
                      error = response.toString(),
                      loadingStatus = LoadingStatus.error
                    },
                  notifyListeners()
                });
      } else {
        emptyRequiredFileds = true;
        notifyListeners();
      }
    } else {
      emptyRequiredFileds = true;
      notifyListeners();
    }
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future changeDate(
    DateTime? dateTime, {
    required bool isFrom,
  }) async {
    if (dateTime != null) {
      if (isFrom) {
        _fromDateTime = dateTime;
      } else {
        _toDateTime = dateTime;
      }

      notifyListeners();
    }
  }

  void changeTime({
    required DateTime dateTime,
    required bool isFrom,
  }) {
    isFrom ? _fromTime = dateTime : _toTime = dateTime;
    notifyListeners();
  }

  void changeWeight(double initialWeight) {
    _weight = weight;
    notifyListeners();
  }

  void changeSwitchValue({
    required int index,
    required bool value,
  }) {
    index == 0 ? _whatsAppSwitchValue = value : _telegramAppSwitchValue = value;
    notifyListeners();
  }

  bool validate({
    required String name,
    required String phone,
  }) {
    bool validate = phone.characters.length == 18 &&
        _fromCity != null &&
        _toCity != null &&
        _fromDateTime != null &&
        _toDateTime != null;

    return validate;
  }

  // MARK: -
  // MARK: - ACTIONS

  void changeCity({
    required bool isFrom,
    required City city,
  }) {
    isFrom ? _fromCity = city : _toCity = city;
    notifyListeners();
  }
}
