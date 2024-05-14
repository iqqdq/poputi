import 'package:dio/dio.dart';
import 'package:poputi/api/models/models.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi(baseUrl: 'http://176.53.162.118/api/')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('cities/')
  Future<CitiesResponse> getCities(
    @Query('page') String page,
    @Query('size') String size,
    @Query('search') String search,
  );

  @GET('announcements/')
  Future<AnnouncementsResponse> getAnnouncements(
    @Query('page') String page,
    @Query('size') String size,
    @Query('departure_from') String departureFrom,
    @Query('arrival_to') String arrivalTo,
  );

  @GET('announcements_last/')
  Future<AnnouncementsResponse> getAnnouncementsLast();

  @POST('announcements/')
  Future<Announcement> postAnnouncement(
      @Body() AnnouncementRequest announcementRequest);
}
