import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException({required this.message, required this.statusCode});

  factory ServerException.fromDioException(DioException e) {
    final code = e.response?.statusCode ?? 500;
    final data = e.response?.data;

    String msg;

    if (data is Map && data["message"] != null) {
      final rawMsg = data["message"];
      if (rawMsg is String) {
        msg = rawMsg;
      } else if (rawMsg is List) {
        msg = rawMsg.join(", ");
      } else {
        msg = rawMsg.toString();
      }
    } else {
      msg = e.message ?? "Unexpected error";
    }

    return ServerException(message: msg, statusCode: code);
  }
}
