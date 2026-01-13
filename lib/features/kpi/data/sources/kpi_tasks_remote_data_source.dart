import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/tasks/data/models/tasks_model.dart';
import 'package:dio/dio.dart';

abstract class KpiTasksRemoteDataSource {
  Future<TasksModel> getKpiTasks({
    required int offset,
    required int limit,
    required int assignedStaffId,
    required String startDate,
    required String endDate,
  });
}

class KpiTasksRemoteDataSourceImpl implements KpiTasksRemoteDataSource {
  final DioClient _client;

  KpiTasksRemoteDataSourceImpl(this._client);

  @override
  Future<TasksModel> getKpiTasks({
    required int offset,
    required int limit,
    required int assignedStaffId,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _client.get(
        ApiUrls.tasks,
        queryParameters: {
          "offset": offset,
          "limit": limit,
          "assignedStaffId": assignedStaffId,
          "kpi.weekStart.min": startDate,
          "kpi.weekStart.max": endDate,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TasksModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch Kpi tasks failed",
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
