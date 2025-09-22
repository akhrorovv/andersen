import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/home/data/models/users_model.dart';
import 'package:dio/dio.dart';

abstract class UsersRemoteDataSource {
  Future<UsersModel> getUsers({
    required int limit,
    required int offset,
    String? search,
    String? status,
  });
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final DioClient _client;

  UsersRemoteDataSourceImpl(this._client);

  @override
  Future<UsersModel> getUsers({
    required int limit,
    required int offset,
    String? search,
    String? status,
  }) async {
    try {
      final response = await _client.get(
        ApiUrls.users,
        queryParameters: {
          "offset": offset,
          "limit": limit,
          if (search != null) "s": search,
          if (status != null) "status": status,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final model = UsersModel.fromJson(response.data);
          return model;
        } catch (e, stack) {
          print(stack);
          throw ServerException(message: "Parsing error: $e", statusCode: 500);
        }
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Fetch events failed",
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
