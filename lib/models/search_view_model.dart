import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:poputi/api/models/models.dart';
import 'package:poputi/repositories/announcements_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SearchViewModel extends ChangeNotifier {
  City? _fromCity;
  City? get fromCity => _fromCity;

  City? _toCity;
  City? get toCity => _toCity;

  DateTime? _dateTime;
  DateTime? get dateTime => _dateTime;

  AnnouncementsResponse? _announcementsResponse;
  List<Announcement>? get announcements => _announcementsResponse?.results;

  SearchViewModel() {
    getLastAnnouncementList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getLastAnnouncementList() async {
    await AnnouncementsRepository()
        .getAnnouncementsLast()
        .then((response) => {
              if (response is AnnouncementsResponse)
                _announcementsResponse = response,
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void changeDate({required DateTime? dateTime}) {
    _dateTime = dateTime;
    notifyListeners();
  }

  void changeCity({
    required bool isFrom,
    required City city,
  }) {
    isFrom ? _fromCity = city : _toCity = city;
    notifyListeners();
  }

  bool validate() {
    return _fromCity != null && _toCity != null;
  }

  // MARK: -
  // MARK: - ACTIONS

  Future openWhatsApp(int index) async {
    if (_announcementsResponse != null) {
      final url =
          "whatsapp://send?phone=${_announcementsResponse!.results[index].phone}";

      if (Platform.isAndroid) {
        AndroidIntent(
          action: 'android.intent.action.VIEW',
          data: url,
        ).launch();
      } else if (Platform.isIOS) {
        await canLaunchUrl(Uri.parse(url))
            ? launchUrl(Uri.parse(url))
            : launchUrlString(url);
      }
    }
  }

  Future openTelegram(int index) async {
    if (_announcementsResponse != null) {
      final url =
          "tg://resolve?phone=${_announcementsResponse!.results[index].phone}";

      if (Platform.isAndroid) {
        AndroidIntent(
          action: 'android.intent.action.VIEW',
          data: url,
        ).launch();
      } else if (Platform.isIOS) {
        await canLaunchUrl(Uri.parse(url))
            ? launchUrl(Uri.parse(url))
            : launchUrlString(url);
      }
    }
  }

  Future call(int index) async {
    await FlutterPhoneDirectCaller.callNumber(
        _announcementsResponse!.results[index].phone);
  }
}
