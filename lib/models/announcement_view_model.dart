import 'package:flutter/material.dart';
import 'package:poputi/api/models/entities/entities.dart';
import 'package:poputi/api/models/requests/announcement_request.dart';
import 'package:poputi/api/models/entities/announcement.dart';
import 'package:poputi/repositories/announcements_repository.dart';
import 'package:poputi/utils/utils.dart';

class AnnouncementViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  bool emptyRequiredFileds = false;

  Announcement? _announcement;
  Announcement? get announcement => _announcement;

  City? _fromCity;
  City? get fromCity => _fromCity;

  City? _toCity;
  City? get toCity => _toCity;

  DateTime? _dateTime;
  DateTime? get dateTime => _dateTime;

  double _weight = 5.0;
  double get weight => _weight;

  bool _whatsAppSwitchValue = false;
  bool get whatsAppSwitchValue => _whatsAppSwitchValue;

  bool _telegramAppSwitchValue = false;
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
        _dateTime != null &&
        name.isNotEmpty) {
      if (phone.replaceAll(RegExp(r'[^0-9]'), '').length >= 11) {
        loadingStatus = LoadingStatus.searching;
        emptyRequiredFileds = false;
        notifyListeners();

        await AnnouncementsRepository()
            .sendAnnouncement(AnnouncementRequest(
              departureDttm: DateTime.now().toUtc(),
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
                    loadingStatus = LoadingStatus.error,
                })
            .whenComplete(() => notifyListeners());
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

  Future changeDate(DateTime? dateTime) async {
    if (dateTime != null) {
      _dateTime = dateTime;
      notifyListeners();
    }
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
  }) =>
      phone.characters.length == 18 &&
      _fromCity != null &&
      _toCity != null &&
      _dateTime != null;

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
