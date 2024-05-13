import 'package:dio/dio.dart';
import 'package:poputi/api/models/models.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi(baseUrl: 'http://176.53.162.118/api/')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  factory ApiClient.create({String? apiUrl}) {
    final dio = Dio();

    if (apiUrl != null) {
      return ApiClient(dio, baseUrl: apiUrl);
    }

    return ApiClient(dio);
  }

  @GET('cities/')
  Future<CitiesResponse> getCities(
    @Query('page') String page,
    @Query('size') String size,
  );

  @GET('announcements/')
  Future<AnnouncementsResponse> getAnnouncements(
    @Query('page') String page,
    @Query('size') String size,
    @Query('departureFrom') String departureFrom,
    @Query('arrivalTo') String arrivalTo,
  );

  @GET('announcements_last/')
  Future<AnnouncementsResponse> getAnnouncementsLast();

  @POST('announcements/')
  Future<Announcement> postAnnouncement(
      @Body() AnnouncementRequest announcementRequest);
}
