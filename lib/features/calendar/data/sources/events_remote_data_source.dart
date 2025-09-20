import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/calendar/data/models/events_model.dart';
import 'package:andersen/features/tasks/data/models/tasks_model.dart';
import 'package:dio/dio.dart';

abstract class EventsRemoteDataSource {
  Future<EventsModel> getEvents({
    required int limit,
    required int offset,
    required int attendeeId,
    required String dateMin,
    required String dateMax,
    String? search,
    String? target,
    int? matterId,
  });
}

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final DioClient _client;

  EventsRemoteDataSourceImpl(this._client);

  @override
  Future<EventsModel> getEvents({
    required int limit,
    required int offset,
    required int attendeeId,
    required String dateMin,
    required String dateMax,
    String? search,
    String? target,
    int? matterId,
  }) async {
    try {
      final response = await _client.get(
        ApiUrls.events,
        queryParameters: {
          "offset": offset,
          "limit": limit,
          "attendeeId": attendeeId,
          if (search != null) "s": search,
          "date.min": dateMin,
          "date.max": dateMax,
          if (target != null) "target": target,
          if (matterId != null) "matterId": matterId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return EventsModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch events failed",
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? e.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
