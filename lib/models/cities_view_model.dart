// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:poputi/entities/response/cities_model.dart';
import 'package:poputi/entities/response/city_model.dart';
import 'package:poputi/repositories/cities_repository.dart';
import 'package:poputi/services/loading_status.dart';
import 'package:poputi/services/pagination.dart';

class CitiesViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;
  Cities? _cities;

  Cities? get cities => _cities;

  CitiesViewModel() {
    getCityList(
      Pagination(number: 1, size: 100),
      '',
    );
  }

  // MARK: -
  // MARK: - API CALL

  Future getCityList(
    Pagination pagination,
    String search,
  ) async {
    if (_cities != null) {
      if (pagination.number > _cities!.pageCount) {
        return;
      }
    }

    if (pagination.number == 1) {
      _cities = null;
    }

    await CitiesRepository()
        .getCities(pagination, search)
        .then((response) => {
              if (response is Cities)
                {
                  {
                    if (_cities == null)
                      {_cities = response}
                    else
                      {
                        response.results.forEach((newCity) {
                          bool found = false;

                          for (var city in _cities!.results) {
                            if (city.id == newCity.id) {
                              found = true;
                            }
                          }

                          if (!found) {
                            _cities!.results.add(newCity);
                          }
                        })
                      }
                  },
                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  // MARK: -
  // MARK: - ACTIONS

  void selectCity(
    int index,
    Function(City) didReturnCity,
  ) {
    if (_cities != null) {
      didReturnCity(_cities!.results[index]);
    }
  }
}
