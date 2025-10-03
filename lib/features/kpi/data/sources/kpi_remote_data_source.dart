import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/kpi/data/models/kpi_results_model.dart';
import 'package:andersen/features/kpi/domain/repositories/kpi_repository.dart';
import 'package:dio/dio.dart';

abstract class KpiRemoteDataSource {
  Future<KpiResultsModel> getKpi(KpiRequest request);
}

class KpiRemoteDataSourceImpl implements KpiRemoteDataSource {
  final DioClient _client;

  KpiRemoteDataSourceImpl(this._client);

  @override
  Future<KpiResultsModel> getKpi(KpiRequest request) async {
    try {
      final response = await _client.get(ApiUrls.kpi, queryParameters: request.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return KpiResultsModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch kpi failed",
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
