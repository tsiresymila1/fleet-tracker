import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/api_responses.dart';
import '../../data/models/position_upload.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST('/initialize')
  Future<DeviceInfoResponse> initializeDevice(
    @Body() Map<String, dynamic> data,
  );

  @POST('/track')
  Future<GenericResponse> sendPosition(
    @Body() Map<String, dynamic> data,
  );

  @POST('/track')
  Future<GenericResponse> sendPositions(
    @Body() List<PositionUpload> data,
  );

  @GET('/device')
  Future<DeviceInfoResponse> getDeviceInfo();

  @PATCH('/device')
  Future<DeviceInfoResponse> updateDeviceInfo(
    @Body() Map<String, dynamic> data,
  );

  @GET('/positions')
  Future<PositionHistoryResponse> getPositionHistory(
    @Query('startDate') String startDate,
    @Query('endDate') String endDate,
  );
}
