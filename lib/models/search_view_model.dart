import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:flutter/material.dart';
import 'package:poputi/components/ru_awesome_calendar_dialog.dart';
import 'package:poputi/constants/titles.dart';
import 'package:poputi/entities/response/city_model.dart';
import 'package:poputi/screens/announcement/announcement_screen.dart';
import 'package:poputi/screens/announcements/announcements_screen.dart';
import 'package:poputi/screens/cities/cities_screen.dart';
import 'package:poputi/screens/privacy_policy/privacy_policy_screen.dart';

class SearchViewModel extends ChangeNotifier {
  City? _fromCity;
  City? _toCity;
  DateTime? _fromDateTime;
  DateTime? _toDateTime;

  City? get fromCity => _fromCity;

  City? get toCity => _toCity;

  DateTime? get fromDateTime => _fromDateTime;

  DateTime? get toDateTime => _toDateTime;

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
            cancelBtnText: Titles.reset,
            weekdayLabels: RuWeekdayLabelsWidget(),
            onResetTap: () => {
                  isFrom ? _fromDateTime = null : _toDateTime = null,
                  notifyListeners()
                });
      },
    );

    if (picked != null) {
      isFrom ? _fromDateTime = picked : _toDateTime = picked;
      notifyListeners();
    }
  }

  bool validate() {
    return _fromCity != null && _toCity != null;
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

  void showAnnouncementScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const AnnouncementScreenWidget(),
        ));
  }

  void showAnnouncementsScreen(BuildContext context) {
    if (_fromCity != null && _toCity != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => AnnouncementsScreenWidget(
                    selectedFromCity: _fromCity!,
                    selectedToCity: _toCity!,
                    selectedFromDateTime: _fromDateTime,
                    selectedToDateTime: _toDateTime,
                  )));
    }
  }

  void showPrivacyPolicyScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const PrivacyPolicyScreenWidget(),
        ));
  }
}
