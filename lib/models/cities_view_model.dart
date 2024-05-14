// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:poputi/api/models/models.dart';
import 'package:poputi/repositories/cities_repository.dart';
import 'package:poputi/utils/utils.dart';

class CitiesViewModel with ChangeNotifier {
  final City? city;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  CitiesResponse? _citiesResponse;

  List<City> get cities => _citiesResponse?.results ?? [];

  CitiesViewModel(this.city) {
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
    if (_citiesResponse != null) {
      if (pagination.number > _citiesResponse!.pageCount) {
        return;
      }
    }

    if (pagination.number == 1) {
      _citiesResponse = null;
    }

    await CitiesRepository()
        .getCities(pagination, search)
        .then((response) => {
              if (response is CitiesResponse)
                {
                  {
                    if (_citiesResponse == null)
                      {_citiesResponse = response}
                    else
                      {
                        response.results.forEach((newCity) {
                          bool found = false;

                          for (var city in _citiesResponse!.results) {
                            if (city.id == newCity.id) {
                              found = true;
                            }
                          }

                          if (!found) {
                            _citiesResponse!.results.add(newCity);
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

  void selectCity(
    int index,
    Function(City) didReturnCity,
  ) {
    if (_citiesResponse != null) {
      didReturnCity(_citiesResponse!.results[index]);
    }
  }
}
