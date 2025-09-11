import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/tasks/data/models/tasks_model.dart';
import 'package:dio/dio.dart';

abstract class TasksRemoteDataSource {
  Future<TasksModel> getTasks({required int offset, required int limit});
}

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final DioClient _client;

  TasksRemoteDataSourceImpl(this._client);

  @override
  Future<TasksModel> getTasks({required int offset, required int limit}) async {
    try {
      final response = await _client.get(
        ApiUrls.tasks,
        queryParameters: {"offset": offset, "limit": limit},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TasksModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch tasks failed",
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
