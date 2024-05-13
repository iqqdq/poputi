import 'package:get_it/get_it.dart';
import 'package:poputi/api/api.dart';
import 'package:poputi/api/models/requests/requests.dart';
import 'package:poputi/api/models/responses/responses.dart';
import 'package:poputi/utils/utils.dart';

class AnnouncementsRepository {
  final GetIt _getIt = GetIt.I;

  Future<Object> getAnnouncements(
    Pagination pagination,
    String? departureFrom,
    String? arrivalTo,
  ) async {
    try {
      AnnouncementsResponse announcementsResponse =
          await _getIt<ApiClient>().getAnnouncements(
        '${pagination.number}',
        '${pagination.size}',
        departureFrom ?? '',
        arrivalTo ?? '',
      );

      return announcementsResponse;
    } catch (e) {
      return e.toString();
    }
  }

  Future<Object> getAnnouncementsLast() async {
    try {
      AnnouncementsResponse announcementsResponse =
          await _getIt<ApiClient>().getAnnouncementsLast();

      return announcementsResponse;
    } catch (e) {
      return e.toString();
    }
  }

  Future<Object> sendAnnouncement(
      AnnouncementRequest announcementRequest) async {
    try {
      Announcement announcement =
          await _getIt<ApiClient>().postAnnouncement(announcementRequest);

      return announcement;
    } catch (e) {
      return e.toString();
    }
  }
}
