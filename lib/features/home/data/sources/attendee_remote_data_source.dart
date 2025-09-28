import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/api/dio_client.dart';
import 'package:andersen/core/common/models/attendee_model.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:dio/dio.dart';

abstract class AttendeeStatusRemoteDataSource {
  Future<AttendeeModel> checkAttendeeStatus();

  Future<AttendeeModel> arrive({
    required double latitude,
    required double longitude,
    String? lateReason,
  });

  Future<AttendeeModel> leave({String? earlyReason});
}

class AttendeeStatusRemoteDataSourceImpl implements AttendeeStatusRemoteDataSource {
  final DioClient _client;

  AttendeeStatusRemoteDataSourceImpl(this._client);

  @override
  Future<AttendeeModel> checkAttendeeStatus() async {
    try {
      final response = await _client.get(ApiUrls.attendeeStatus);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AttendeeModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Update event failed",
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      final msg = e.response?.data["message"] ?? e.message ?? "Unexpected error";
      final code = e.response?.statusCode ?? 500;
      throw ServerException(message: msg, statusCode: code);
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<AttendeeModel> arrive({
    required double latitude,
    required double longitude,
    String? lateReason,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "latitude": latitude,
        "longitude": longitude,
        if (lateReason != null) "late_reason": lateReason,
      };

      final response = await _client.post(ApiUrls.arrive, data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AttendeeModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Update event failed",
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      final msg = e.response?.data["message"] ?? e.message ?? "Unexpected error";
      final code = e.response?.statusCode ?? 500;
      throw ServerException(message: msg, statusCode: code);
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<AttendeeModel> leave({String? earlyReason}) async {
    try {
      final Map<String, dynamic> body = {if (earlyReason != null) "early_reason": earlyReason};

      final response = await _client.post(ApiUrls.leave, data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AttendeeModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? "Update event failed",
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      final msg = e.response?.data["message"] ?? e.message ?? "Unexpected error";
      final code = e.response?.statusCode ?? 500;
      throw ServerException(message: msg, statusCode: code);
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
