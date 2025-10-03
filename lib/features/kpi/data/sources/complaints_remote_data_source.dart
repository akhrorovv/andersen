import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/kpi/data/models/complaints_model.dart';
import 'package:andersen/features/kpi/domain/repositories/complaints_repository.dart';
import 'package:dio/dio.dart';

abstract class ComplaintsRemoteDataSource {
  Future<ComplaintsModel> getComplaints(ComplaintsRequest request);
}

class ComplaintsRemoteDataSourceImpl implements ComplaintsRemoteDataSource {
  final DioClient _client;

  ComplaintsRemoteDataSourceImpl(this._client);

  @override
  Future<ComplaintsModel> getComplaints(ComplaintsRequest request) async {
    try {
      final response = await _client.get(ApiUrls.complaints, queryParameters: request.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ComplaintsModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch complaints failed",
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
