import 'package:poputi/entities/request/announcement_request_model.dart';
import 'package:poputi/entities/response/announcement_model.dart';
import 'package:poputi/entities/response/announcements_model.dart';
import 'package:poputi/services/pagination.dart';
import 'package:poputi/services/urls.dart';
import 'package:poputi/services/web_service.dart';

class AnnouncementsRepository {
  final webService = WebService();

  Future<Object> getAnnouncements(
    Pagination pagination,
    String departureFrom,
    String arrivalTo,
    String departureDttmAfter,
    String departureDttmBefore,
    String arrivalDttmAfter,
    String arrivalDttmBefore,
  ) async {
    dynamic json = await webService.get(
        '$announcementsUrl?page=${pagination.number}&size=${pagination.size}&departure_from=$departureFrom&arrival_to=$arrivalTo&departure_dttm_after=$departureDttmAfter&departure_dttm_before=$departureDttmBefore&arrival_dttm_after=$arrivalDttmAfter&arrival_dttm_before=$arrivalDttmBefore&ordering=departure_dttm');

    try {
      return Announcements.fromJson(json);
    } catch (e) {
      return e.toString();
    }
  }

  Future<Object> sendAnnouncement(
      AnnouncementRequest announcementRequest) async {
    dynamic json = await webService.post(
      announcementsUrl,
      announcementRequest.toJson(),
    );

    try {
      return Announcement.fromJson(json);
    } catch (e) {
      return e.toString();
    }
  }
}
