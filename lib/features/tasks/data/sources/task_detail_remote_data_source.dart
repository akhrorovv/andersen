import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/activities/data/models/activities_model.dart';
import 'package:andersen/features/tasks/data/models/task_model.dart';
import 'package:dio/dio.dart';

abstract class TaskDetailRemoteDataSource {
  Future<TaskModel> getTaskDetail({required int taskId});

  Future<ActivitiesModel> getTaskActivities({
    required int offset,
    required int limit,
    int? createdById,
    required int taskId,
  });

  Future<TaskModel> updateTask(int taskId, Map<String, dynamic> body);
}

class TaskDetailRemoteDataSourceImpl implements TaskDetailRemoteDataSource {
  final DioClient _client;

  TaskDetailRemoteDataSourceImpl(this._client);

  @override
  Future<TaskModel> getTaskDetail({required int taskId}) async {
    try {
      final response = await _client.get(ApiUrls.taskDetail(taskId));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch task detail failed",
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

  @override
  Future<ActivitiesModel> getTaskActivities({
    required int offset,
    required int limit,
    int? createdById,
    required int taskId,
  }) async {
    try {
      final response = await _client.get(
        ApiUrls.activities,
        queryParameters: {
          "offset": offset,
          "limit": limit,
          "createdById": DBService.user?.id,
          "taskId": taskId,
        },
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

  @override
  Future<TaskModel> updateTask(int taskId, Map<String, dynamic> body) async {
    try {
      final response = await _client.patch(
        ApiUrls.taskUpdate(taskId),
        data: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch task detail failed",
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
