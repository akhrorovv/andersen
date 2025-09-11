import 'package:andersen/core/utils/db_service.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// This interceptor is used to show request and response logs
class LoggerInterceptor extends Interceptor {
  static Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: true),
  );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger.e(
      '${options.method} request ==> $requestPath\n'
      'Status Code: ${err.response?.data['statusCode']}\n'
      'Error message: ${err.response?.data['message']}',
    ); //Debug log
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    logger.i(
      '${options.method} request ==> $requestPath\n\n'
      'HEADERS: ${options.headers}\n'
      'QUERY PARAMETERS: ${options.queryParameters}\n'
      'BODY: ${options.data}',
    ); //Info log
    handler.next(options); // continue with the Request
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d(
      'Status Code: ${response.statusCode}\n'
      // 'HEADERS: ${response.headers}\n'
      'Data: ${response.data}',
    ); // Debug log
    handler.next(response);
  }
}

class AuthorizationInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = DBService.accessToken;
    options.headers['Authorization'] = "Bearer $token";
    handler.next(options); // continue with the Request
  }
}
