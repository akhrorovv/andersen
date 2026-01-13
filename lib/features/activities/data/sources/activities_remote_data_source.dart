import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/activities/data/models/activities_model.dart';
import 'package:dio/dio.dart';

abstract class ActivitiesRemoteDataSource {
  Future<ActivitiesModel> getActivities({
    required int offset,
    required int limit,
    int? createdById,
  });
}

class ActivitiesRemoteDataSourceImpl implements ActivitiesRemoteDataSource {
  final DioClient _client;

  ActivitiesRemoteDataSourceImpl(this._client);

  @override
  Future<ActivitiesModel> getActivities({
    required int offset,
    required int limit,
    int? createdById,
  }) async {
    try {
      final response = await _client.get(
        ApiUrls.activities,
        queryParameters: {"offset": offset, "limit": limit, "createdById": DBService.user?.id},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ActivitiesModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch activities failed",
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
