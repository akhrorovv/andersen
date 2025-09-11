import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/features/auth/data/models/login_response_model.dart';
import 'package:andersen/features/auth/domain/usecases/login_params.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginParams params, {String? deviceId});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<LoginResponseModel> login(
    LoginParams params, {
    String? deviceId,
  }) async {
    try {
      Map<String, dynamic> body;

      if (deviceId == null) {
        body = {
          "phone": params.phone,
          "password": params.password,
          "device": {
            "model": params.device?.model,
            "version": params.device?.version,
            "locale": params.device?.locale,
            "fcm_token": params.device?.fcmToken,
          },
        };
      } else {
        body = {
          "phone": params.phone,
          "password": params.password,
          "deviceId": deviceId,
        };
      }

      final response = await _client.post(ApiUrls.login, data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponseModel.fromJson(response.data);
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
}
