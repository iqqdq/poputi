import 'package:poputi/entities/response/cities_model.dart';
import 'package:poputi/services/pagination.dart';
import 'package:poputi/services/urls.dart';
import 'package:poputi/services/web_service.dart';

class CitiesRepository {
  Future<Object> getCities(
    Pagination pagination,
    String search,
  ) async {
    dynamic json = await WebService().get(
        '$citiesUrl?page=${pagination.number}&size=${pagination.size}&search=$search');

    try {
      return Cities.fromJson(json);
    } catch (e) {
      return e.toString();
    }
  }
}
