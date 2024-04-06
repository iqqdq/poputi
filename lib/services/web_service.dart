import 'package:dio/dio.dart';
import 'dart:convert';

class WebService {
  final _dio = Dio();

  Future<dynamic> get(String url) async {
    try {
      Response response = await _dio.get(url);

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.data;
      }
    }
  }

  Future<dynamic> post(String url, Object object) async {
    try {
      Response response = await _dio.post(
        url,
        data: jsonEncode(object),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.data;
      }
    }
  }
}
