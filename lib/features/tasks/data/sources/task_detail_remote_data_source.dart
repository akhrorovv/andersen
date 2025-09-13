import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/tasks/data/models/task_model.dart';
import 'package:andersen/features/tasks/data/models/tasks_model.dart';
import 'package:dio/dio.dart';

abstract class TaskDetailRemoteDataSource {
  Future<TaskModel> getTaskDetail({required int taskId});
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
}
