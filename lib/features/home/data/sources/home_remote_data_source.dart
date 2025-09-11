import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/home/data/models/active_status_model.dart';
import 'package:andersen/features/home/data/models/user_model.dart';
import 'package:dio/dio.dart';

abstract class HomeRemoteDataSource {
  Future<UserModel> getProfile();

  Future<ActiveStatusModel> getActiveStatus();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient _client;

  HomeRemoteDataSourceImpl(this._client);

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _client.get(ApiUrls.profile);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Login failed",
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

  @override
  Future<ActiveStatusModel> getActiveStatus() async {
    try {
      final response = await _client.get(ApiUrls.attendeeStatus);

      if (response.statusCode == 200) {
        return ActiveStatusModel.fromJson(response.data);
      } else if (response.statusCode == 404) {
        return const ActiveStatusModel(isActive: false);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Failed",
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const ActiveStatusModel(isActive: false);
      }
      throw ServerException(
        message: e.message ?? e.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
