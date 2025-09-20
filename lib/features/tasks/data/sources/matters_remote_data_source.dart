import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/tasks/data/models/matters_model.dart';
import 'package:dio/dio.dart';

abstract class MattersRemoteDataSource {
  Future<MattersModel> getMatters({
    required int offset,
    required int limit,
    required int clientId,
    String? search,
    bool? taskCreatable,
  });
}

class MattersRemoteDataSourceImpl implements MattersRemoteDataSource {
  final DioClient _client;

  MattersRemoteDataSourceImpl(this._client);

  @override
  Future<MattersModel> getMatters({
    required int offset,
    required int limit,
    required int clientId,
    String? search,
    bool? taskCreatable,
  }) async {
    try {
      final response = await _client.get(
        ApiUrls.matters,
        queryParameters: {
          "offset": offset,
          "limit": limit,
          "clientId": clientId,
          if (search != null) "s": search,
          if (taskCreatable != null) "task_createable": taskCreatable,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MattersModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch matters failed",
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
