import 'package:get_it/get_it.dart';
import 'package:poputi/api/api.dart';
import 'package:poputi/api/models/responses/responses.dart';
import 'package:poputi/utils/utils.dart';

class CitiesRepository {
  Future<Object> getCities(
    Pagination pagination,
    String search,
  ) async {
    try {
      CitiesResponse citiesResponse = await GetIt.I<ApiClient>().getCities(
        '${pagination.number}',
        '${pagination.size}',
        search,
      );

      return citiesResponse;
    } catch (e) {
      return e.toString();
    }
  }
}
