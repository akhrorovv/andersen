import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/tasks/data/models/matters_model.dart';
import 'package:andersen/features/tasks/data/models/task_types_model.dart';
import 'package:dio/dio.dart';

abstract class TaskTypesRemoteDataSource {
  Future<TaskTypesModel> getTypes({
    required int offset,
    required int limit,
    String? search,
  });
}

class TaskTypesRemoteDataSourceImpl implements TaskTypesRemoteDataSource {
  final DioClient _client;

  TaskTypesRemoteDataSourceImpl(this._client);

  @override
  Future<TaskTypesModel> getTypes({
    required int offset,
    required int limit,
    String? search,
  }) async {
    try {
      final response = await _client.get(
        ApiUrls.taskTypes,
        queryParameters: {
          "offset": offset,
          "limit": limit,
          if (search != null) "s": search,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskTypesModel.fromJson(response.data);
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
