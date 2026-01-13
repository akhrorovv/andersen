import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/home/data/models/activity_types_model.dart';
import 'package:dio/dio.dart';

abstract class ActivityTypesRemoteDataSource {
  Future<ActivityTypesModel> getTypes({
    required int offset,
    required int limit,
    String? search,
  });
}

class ActivityTypesRemoteDataSourceImpl implements ActivityTypesRemoteDataSource {
  final DioClient _client;

  ActivityTypesRemoteDataSourceImpl(this._client);

  @override
  Future<ActivityTypesModel> getTypes({
    required int offset,
    required int limit,
    String? search,
  }) async {
    try {
      final response = await _client.get(
        ApiUrls.activityTypes,
        queryParameters: {
          "offset": offset,
          "limit": limit,
          if (search != null) "s": search,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ActivityTypesModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch activity types failed",
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
