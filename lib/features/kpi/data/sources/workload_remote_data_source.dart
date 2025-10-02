import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/kpi/data/models/workload_model.dart';
import 'package:andersen/features/kpi/domain/repositories/workload_repository.dart';
import 'package:dio/dio.dart';

abstract class WorkloadRemoteDataSource {
  Future<List<WorkloadModel>> getWorkload(WorkloadRequest request);
}

class WorkloadRemoteDataSourceImpl implements WorkloadRemoteDataSource {
  final DioClient _client;

  WorkloadRemoteDataSourceImpl(this._client);

  @override
  Future<List<WorkloadModel>> getWorkload(WorkloadRequest request) async {
    try {
      final response = await _client.get(ApiUrls.workload, queryParameters: request.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data is List) {
          return data.map((e) => WorkloadModel.fromJson(e)).toList();
        } else {
          throw ServerException(
            message: "Invalid workload response format (expected List)",
            statusCode: response.statusCode ?? 500,
          );
        }
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch workload failed",
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ServerException.fromDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
