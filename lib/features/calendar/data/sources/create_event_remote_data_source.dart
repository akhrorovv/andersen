import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/calendar/data/models/event_model.dart';
import 'package:dio/dio.dart';

abstract class CreateEventRemoteDataSource {
  Future<EventModel> createEvent(Map<String, dynamic> body);
}

class CreateEventRemoteDataSourceImpl implements CreateEventRemoteDataSource {
  final DioClient _client;

  CreateEventRemoteDataSourceImpl(this._client);

  @override
  Future<EventModel> createEvent(Map<String, dynamic> body) async {
    try {
      final response = await _client.post(ApiUrls.createEvent, data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return EventModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "New Event create failed",
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      // Check if it's a network error
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      final msg = e.response?.data["message"] ?? e.message ?? "Unexpected error";
      final code = e.response?.statusCode ?? 500;
      throw ServerException(message: msg, statusCode: code);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
