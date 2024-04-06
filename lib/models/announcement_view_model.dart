import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:flutter/material.dart';
import 'package:poputi/components/ru_awesome_calendar_dialog.dart';
import 'package:poputi/components/time_picker_modal_widget.dart';
import 'package:poputi/components/weight_modal_widget.dart';
import 'package:poputi/constants/titles.dart';
import 'package:poputi/entities/request/announcement_request_model.dart';
import 'package:poputi/entities/response/announcement_model.dart';
import 'package:poputi/entities/response/city_model.dart';
import 'package:poputi/repositories/announcements_repository.dart';
import 'package:poputi/screens/cities/cities_screen.dart';
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
    BuildContext context,
    double? price,
    String name,
    String phone,
    String comment,
  ) async {
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
                isUtc: false)
            .toIso8601String();

        DateTime to = DateTime(
          _toDateTime!.year,
          _toDateTime!.month,
          _toDateTime!.day,
          _toTime.hour,
          _toTime.minute,
        );

        String toIso = DateTime.fromMillisecondsSinceEpoch(
                to.millisecondsSinceEpoch,
                isUtc: false)
            .toIso8601String();

        await AnnouncementsRepository()
            .sendAnnouncement(AnnouncementRequest(
              departureDttm: fromIso,
              arrivalDttm: toIso,
              parcelWeight: _weight,
              price: price,
              name: name,
              phone: phone.contains('+')
                  ? '+' + phone.replaceAll(RegExp(r'[^0-9]'), '')
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

        Future.delayed(
          const Duration(milliseconds: 200),
          () => showOkAlertDialog(
            context: context,
            title: Titles.warning,
            message: phone.isEmpty
                ? Titles.required_fields_message
                : Titles.phone_validate,
          ),
        );
      }
    } else {
      emptyRequiredFileds = true;
      notifyListeners();

      Future.delayed(
        const Duration(milliseconds: 200),
        () => showOkAlertDialog(
          context: context,
          title: Titles.warning,
          message: Titles.required_fields_message,
        ),
      );
    }
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future changeDate(
    BuildContext context,
    bool isFrom,
  ) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return RuAwesomeCalendarDialog(
          selectionMode: SelectionMode.single,
          confirmBtnText: Titles.add,
          cancelBtnText: Titles.cancel,
          weekdayLabels: RuWeekdayLabelsWidget(),
        );
      },
    );

    if (picked != null) {
      if (isFrom) {
        _fromDateTime = picked;
      } else {
        _toDateTime = picked;
      }

      notifyListeners();
    }
  }

  void changeTime(
    BuildContext context,
    DateTime dateTime,
    bool isFrom,
  ) {
    showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return TimePickerModalWidget(
            initialDateTime: dateTime,
            onUpdate: (dateTime) => {
                  isFrom ? _fromTime = dateTime : _toTime = dateTime,
                  notifyListeners()
                });
      },
    );
  }

  void changeWeight(
    BuildContext context,
    double initialWeight,
  ) {
    showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return WeightModalWidget(
            initialWeight: initialWeight,
            onUpdate: (weight) => {
                  _weight = weight,
                  notifyListeners(),
                });
      },
    );
  }

  void changeSwitchValue(
    int index,
    bool value,
  ) {
    index == 0 ? _whatsAppSwitchValue = value : _telegramAppSwitchValue = value;
    notifyListeners();
  }

  bool validate(
    String name,
    String phone,
  ) {
    bool validate = phone.characters.length == 18 &&
        _fromCity != null &&
        _toCity != null &&
        _fromDateTime != null &&
        _toDateTime != null;

    return validate;
  }

  // MARK: -
  // MARK: - ACTIONS

  void showCitiesScreen(
    BuildContext context,
    bool isFrom,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CitiesScreenWidget(
                city: isFrom ? _fromCity : _toCity,
                didReturnCity: (city) => {
                      isFrom ? _fromCity = city : _toCity = city,
                      notifyListeners()
                    })));
  }
}
