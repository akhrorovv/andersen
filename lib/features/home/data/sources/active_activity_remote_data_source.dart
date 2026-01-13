import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/activities/data/models/activity_model.dart';
import 'package:dio/dio.dart';

abstract class ActiveActivityRemoteDataSource {
  Future<ActivityModel?> getActiveActivity();
}

class ActiveActivityRemoteDataSourceImpl implements ActiveActivityRemoteDataSource {
  final DioClient _client;

  ActiveActivityRemoteDataSourceImpl(this._client);

  @override
  Future<ActivityModel?> getActiveActivity() async {
    try {
      final response = await _client.get(ApiUrls.activeActivity);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data.toString().isEmpty) {
          return null;
        }
        return ActivityModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch active activity failed",
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
