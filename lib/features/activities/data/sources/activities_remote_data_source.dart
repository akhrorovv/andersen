import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/activities/data/models/activities_model.dart';
import 'package:dio/dio.dart';

abstract class ActivitiesRemoteDataSource {
  Future<ActivitiesModel> getActivities({
    required int offset,
    required int limit,
  });
}

class ActivitiesRemoteDataSourceImpl implements ActivitiesRemoteDataSource {
  final DioClient _client;

  ActivitiesRemoteDataSourceImpl(this._client);

  @override
  Future<ActivitiesModel> getActivities({
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await _client.get(
        ApiUrls.activities,
        queryParameters: {"offset": offset, "limit": limit},
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
      throw ServerException(
        message: e.message ?? e.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
