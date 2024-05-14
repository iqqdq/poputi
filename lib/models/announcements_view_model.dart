// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:poputi/api/models/models.dart';
import 'package:poputi/extensions/extensions.dart';
import 'package:poputi/repositories/announcements_repository.dart';
import 'package:poputi/utils/utils.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AnnouncementsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final City selectedFromCity;
  final City selectedToCity;

  City? _fromCity;
  City? get fromCity => _fromCity;

  City? _toCity;
  City? get toCity => _toCity;

  AnnouncementsResponse? _announcementsResponse;
  List<Announcement> get announcements => _announcementsResponse?.results ?? [];

  AnnouncementsViewModel(
    this.selectedFromCity,
    this.selectedToCity,
  ) {
    getAnnouncementList(
      Pagination(number: 1, size: 100),
      selectedFromCity.id,
      selectedToCity.id,
    );
  }

  // MARK: -
  // MARK: - API CALL

  Future getAnnouncementList(
    Pagination pagination,
    int? departureFrom,
    int? arrivalTo,
  ) async {
    if (_announcementsResponse != null) {
      if (pagination.number > _announcementsResponse!.pageCount) {
        return;
      }

      if (pagination.number == 1 &&
          _announcementsResponse!.results.isNotEmpty) {
        loadingStatus = LoadingStatus.searching;
        _announcementsResponse!.results.clear();

        Future.delayed(
            const Duration(milliseconds: 200), () => notifyListeners());
      }
    }

    await AnnouncementsRepository()
        .getAnnouncements(
          pagination,
          (departureFrom ?? '').toString(),
          (arrivalTo ?? '').toString(),
        )
        .then((response) => {
              if (response is AnnouncementsResponse)
                {
                  {
                    if (_announcementsResponse == null)
                      _announcementsResponse = response
                    else
                      {
                        response.results.forEach((newAnnouncement) {
                          bool found = false;

                          for (var announcement
                              in _announcementsResponse!.results) {
                            if (announcement.id == newAnnouncement.id) {
                              found = true;
                            }
                          }

                          if (!found) {
                            _announcementsResponse!.results
                                .add(newAnnouncement);
                          }
                        })
                      }
                  },
                  _announcementsResponse!.results
                      .removeWhere((element) => element.departureDttm.isPast()),
                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

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
