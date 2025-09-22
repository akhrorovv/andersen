import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:dio/dio.dart';

abstract class DeleteEventRemoteDataSource {
  Future<bool> deleteEvent(int eventId);
}

class DeleteEventRemoteDataSourceImpl implements DeleteEventRemoteDataSource {
  final DioClient _client;

  DeleteEventRemoteDataSourceImpl(this._client);

  @override
  Future<bool> deleteEvent(int eventId) async {
    try {
      final response = await _client.delete(ApiUrls.deleteEvent(eventId));

      if (response.statusCode == 200) {
        final data = response.data;
        return data['status'] == 'success';
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Event delete failed",
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? "Delete failed",
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }
}
