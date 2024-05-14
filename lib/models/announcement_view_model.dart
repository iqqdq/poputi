import 'package:flutter/material.dart';
import 'package:poputi/api/models/entities/entities.dart';
import 'package:poputi/api/models/requests/announcement_request.dart';
import 'package:poputi/api/models/entities/announcement.dart';
import 'package:poputi/repositories/announcements_repository.dart';
import 'package:poputi/utils/utils.dart';

class AnnouncementViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;

  Announcement? _announcement;
  Announcement? get announcement => _announcement;

  City? _fromCity;
  City? get fromCity => _fromCity;

  City? _toCity;
  City? get toCity => _toCity;

  DateTime? _dateTime;
  DateTime? get dateTime => _dateTime;

  bool _whatsAppSwitchValue = false;
  bool get whatsAppSwitchValue => _whatsAppSwitchValue;

  bool _telegramAppSwitchValue = false;
  bool get telegramAppSwitchValue => _telegramAppSwitchValue;

  // MARK: -
  // MARK: - API CALL

  Future createAnnouncement({
    required String name,
    required String phone,
    required String comment,
  }) async {
    loadingStatus = LoadingStatus.searching;

    await AnnouncementsRepository()
        .sendAnnouncement(AnnouncementRequest(
          departureFrom: _fromCity!.id,
          arrivalTo: _toCity!.id,
          departureDttm: _dateTime!.toUtc(),
          name: name,
          phone: phone,
          hasWhatsapp: _whatsAppSwitchValue,
          hasTelegram: _telegramAppSwitchValue,
          comment: comment,
          price: 0.0,
          parcelWeight: 0.0,
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
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future changeDate(DateTime? dateTime) async {
    if (dateTime != null) {
      _dateTime = dateTime;
      notifyListeners();
    }
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
