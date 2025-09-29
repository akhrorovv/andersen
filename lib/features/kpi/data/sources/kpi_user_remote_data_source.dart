import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/kpi/data/models/kpi_user_model.dart';
import 'package:dio/dio.dart';

abstract class KpiUserRemoteDataSource {
  Future<KpiUserModel> getUserKpi({required int userId});
}

class KpiUserRemoteDataSourceImpl implements KpiUserRemoteDataSource {
  final DioClient _client;

  KpiUserRemoteDataSourceImpl(this._client);

  @override
  Future<KpiUserModel> getUserKpi({required int userId}) async {
    try {
      final response = await _client.get(ApiUrls.kpiUser(userId));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return KpiUserModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch user kpi failed",
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
