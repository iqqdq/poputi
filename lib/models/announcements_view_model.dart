// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:poputi/entities/response/announcements_model.dart';
import 'package:poputi/entities/response/city_model.dart';
import 'package:poputi/repositories/announcements_repository.dart';
import 'package:poputi/services/loading_status.dart';
import 'package:poputi/services/pagination.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AnnouncementsViewModel with ChangeNotifier {
  // INIT
  final City selectedFromCity;
  final City selectedToCity;
  DateTime? selectedFromDateTime;
  DateTime? selectedToDateTime;
  // DATA
  LoadingStatus loadingStatus = LoadingStatus.searching;
  City? _fromCity;
  City? _toCity;
  DateTime? _fromDateTime;
  DateTime? _toDateTime;
  Announcements? _announcements;

  City? get fromCity => _fromCity;

  City? get toCity => _toCity;

  DateTime? get fromDateTime => _fromDateTime;

  DateTime? get toDateTime => _toDateTime;

  Announcements? get announcements => _announcements;

  AnnouncementsViewModel(
    this.selectedFromCity,
    this.selectedToCity,
    this.selectedFromDateTime,
    this.selectedToDateTime,
  ) {
    _fromDateTime = selectedFromDateTime;
    _toDateTime = selectedToDateTime;

    getAnnouncementList(
      Pagination(number: 1, size: 100),
      selectedFromCity.id,
      selectedToCity.id,
      _fromDateTime,
      _toDateTime,
    );
  }

  // MARK: -
  // MARK: - API CALL

  Future getAnnouncementList(
    Pagination pagination,
    int? departureFrom,
    int? arrivalTo,
    DateTime? departureDttm,
    DateTime? arrivalDttm,
  ) async {
    if (_announcements != null) {
      if (pagination.number > _announcements!.pageCount) {
        return;
      }

      if (pagination.number == 1 && _announcements!.results.isNotEmpty) {
        loadingStatus = LoadingStatus.searching;
        _announcements!.results.clear();

        Future.delayed(
            const Duration(milliseconds: 200), () => notifyListeners());
      }
    }

    DateTime? departureAfter = departureDttm == null
        ? null
        : DateTime(
            departureDttm.year,
            departureDttm.month,
            departureDttm.day,
            0,
            0,
            0,
          );

    String? departureAfterIso = departureAfter == null
        ? ''
        : DateTime.fromMillisecondsSinceEpoch(
            departureAfter.millisecondsSinceEpoch,
            isUtc: false,
          ).toIso8601String();

    DateTime? departureBefore = departureAfter == null
        ? null
        : DateTime(
            departureAfter.year,
            departureAfter.month,
            departureAfter.day,
            23,
            59,
            59,
          );

    String departureBeforeIso = departureBefore == null
        ? ''
        : DateTime.fromMillisecondsSinceEpoch(
                departureBefore.millisecondsSinceEpoch,
                isUtc: false)
            .toIso8601String();

    DateTime? arrivalAfter = arrivalDttm == null
        ? null
        : DateTime(
            arrivalDttm.year, arrivalDttm.month, arrivalDttm.day, 0, 0, 0);

    String? arrivalAfterIso = arrivalAfter == null
        ? ''
        : DateTime.fromMillisecondsSinceEpoch(
                arrivalAfter.millisecondsSinceEpoch,
                isUtc: false)
            .toIso8601String();

    DateTime? arrivalBefore = arrivalAfter == null
        ? null
        : DateTime(
            arrivalAfter.year,
            arrivalAfter.month,
            arrivalAfter.day,
            23,
            59,
            0,
          );

    String? arrivalBeforeIso = arrivalBefore == null
        ? ''
        : DateTime.fromMillisecondsSinceEpoch(
                arrivalBefore.millisecondsSinceEpoch,
                isUtc: false)
            .toIso8601String();

    if (departureDttm == null) {
      departureAfterIso = DateTime.fromMillisecondsSinceEpoch(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
                0, 0, 0)
            .millisecondsSinceEpoch,
        isUtc: false,
      ).toIso8601String();
    }

    await AnnouncementsRepository()
        .getAnnouncements(
          pagination,
          (departureFrom ?? '').toString(),
          (arrivalTo ?? '').toString(),
          departureAfterIso,
          departureBeforeIso,
          arrivalAfterIso,
          arrivalBeforeIso,
        )
        .then((response) => {
              if (response is Announcements)
                {
                  {
                    if (_announcements == null)
                      {_announcements = response}
                    else
                      {
                        response.results.forEach((newAnnouncement) {
                          bool found = false;

                          for (var announcement in _announcements!.results) {
                            if (announcement.id == newAnnouncement.id) {
                              found = true;
                            }
                          }

                          if (!found) {
                            _announcements!.results.add(newAnnouncement);
                          }
                        })
                      }
                  },
                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
              notifyListeners()
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future changeDate({
    required Pagination pagination,
    required DateTime? selectedDateTime,
    required bool isFrom,
  }) async {
    if (selectedDateTime == null) {
      isFrom ? _fromDateTime = null : _toDateTime = null;
      notifyListeners();
    } else {
      DateTime dateTime = DateTime(
        selectedDateTime.year,
        selectedDateTime.month,
        selectedDateTime.day,
        0,
        0,
        0,
      );
      isFrom ? _fromDateTime = dateTime : _toDateTime = dateTime;

      getAnnouncementList(
        pagination,
        _fromCity?.id ?? selectedFromCity.id,
        _toCity?.id ?? selectedToCity.id,
        _fromDateTime ?? selectedFromDateTime,
        _toDateTime ?? selectedToDateTime,
      );
    }
  }

  Future changeCity({
    required bool isFrom,
    required City city,
  }) async {
    isFrom ? _fromCity = city : _toCity = city;
    notifyListeners();
  }

  // MARK: -
  // MARK: - ACTIONS

  Future openWhatsApp(int index) async {
    if (announcements != null) {
      final phone = announcements!.results[index].phone;
      final url = "whatsapp://send?phone=$phone";

      if (Platform.isAndroid) {
        AndroidIntent intent =
            AndroidIntent(action: 'android.intent.action.VIEW', data: url);
        intent.launch();
      } else if (Platform.isIOS) {
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url));
        }
      }
    }
  }

  Future openTelegram(int index) async {
    if (announcements != null) {
      final phone = announcements!.results[index].phone;
      final url = "tg://resolve?phone=$phone";

      if (Platform.isAndroid) {
        AndroidIntent intent =
            AndroidIntent(action: 'android.intent.action.VIEW', data: url);
        intent.launch();
      } else if (Platform.isIOS) {
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url));
        } else {
          launchUrlString(url);
        }
      }
    }
  }

  Future call(int index) async {
    await FlutterPhoneDirectCaller.callNumber(
        announcements!.results[index].phone);
  }
}
