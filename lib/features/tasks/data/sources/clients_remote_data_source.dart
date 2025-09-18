import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/common/models/clients_model.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:dio/dio.dart';

abstract class ClientsRemoteDataSource {
  Future<ClientsModel> getClients({
    required int offset,
    required int limit,
    String? search,
  });
}

class ClientsRemoteDataSourceImpl implements ClientsRemoteDataSource {
  final DioClient _client;

  ClientsRemoteDataSourceImpl(this._client);

  @override
  Future<ClientsModel> getClients({
    required int offset,
    required int limit,
    String? search,
  }) async {
    try {
      final response = await _client.get(
        ApiUrls.clients,
        queryParameters: {
          "offset": offset,
          "limit": limit,
          if (search != null) "s": search,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ClientsModel.fromJson(response.data);
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
