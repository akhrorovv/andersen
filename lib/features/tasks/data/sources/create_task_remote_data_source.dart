import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/tasks/data/models/task_model.dart';
import 'package:dio/dio.dart';

abstract class CreateTaskRemoteDataSource {
  Future<TaskModel> createTask(Map<String, dynamic> body);
}

class CreateTaskRemoteDataSourceImpl implements CreateTaskRemoteDataSource {
  final DioClient _client;

  CreateTaskRemoteDataSourceImpl(this._client);

  @override
  Future<TaskModel> createTask(Map<String, dynamic> body) async {
    try {
      final response = await _client.post(ApiUrls.createTask, data: body);

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
