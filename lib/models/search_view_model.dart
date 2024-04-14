import 'package:flutter/material.dart';
import 'package:poputi/entities/response/city_model.dart';

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

  Future changeDate({
    required DateTime? dateTime,
    required bool isFrom,
  }) async {
    if (dateTime == null) {
      isFrom ? _fromDateTime = null : _toDateTime = null;
    } else {
      isFrom ? _fromDateTime = dateTime : _toDateTime = dateTime;
    }

    notifyListeners();
  }

  Future changeCity({
    required bool isFrom,
    required City city,
  }) async {
    isFrom ? _fromCity = city : _toCity = city;
    notifyListeners();
  }

  bool validate() {
    return _fromCity != null && _toCity != null;
  }
}
