import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/activities/data/models/activities_model.dart';
import 'package:dio/dio.dart';

abstract class KpiActivitiesRemoteDataSource {
  Future<ActivitiesModel> getKpiActivities({
    required int offset,
    required int limit,
    required int createdById,
    required String startDate,
    required String endDate,
  });
}

class KpiActivitiesRemoteDataSourceImpl implements KpiActivitiesRemoteDataSource {
  final DioClient _client;

  KpiActivitiesRemoteDataSourceImpl(this._client);

  @override
  Future<ActivitiesModel> getKpiActivities({
    required int offset,
    required int limit,
    required int createdById,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _client.get(
        ApiUrls.activities,
        queryParameters: {
          "offset": offset,
          "limit": limit,
          "createdById": createdById,
          "kpi.weekStart.min": startDate,
          "kpi.weekStart.max": endDate,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ActivitiesModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch kpi activities failed",
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      final msg = e.response?.data["message"] ?? e.message ?? "Unexpected error";
      final code = e.response?.statusCode ?? 500;

      throw ServerException(message: msg, statusCode: code);
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
