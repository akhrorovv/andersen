import 'dart:developer';

import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/navigation/app_router.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/auth/presentation/pages/checking_page.dart';
import 'package:andersen/features/auth/presentation/pages/login_page.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
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

    final statusCode = err.response?.statusCode;
    final errorData = err.response?.data;
    String message;

    if (errorData is Map && errorData.containsKey('message')) {
      message = errorData['message'].toString();
    } else {
      message = err.message ?? 'Unknown error';
    }

    logger.e(
      '${options.method} request ==> $requestPath\n'
      'Status Code: $statusCode\n'
      'Error message: $message',
    );

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
      'Api: ${response.realUri.path}\n'
      'Status Code: ${response.statusCode}\n'
      // 'HEADERS: ${response.headers}\n'
      'Data: ${response.data}',
    ); // Debug log
    handler.next(response);
  }
}

class AuthorizationInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = DBService.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $token";
    }
    handler.next(options); // continue with the Request
  }
}

class TokenInterceptor extends Interceptor {
  final Dio _dio;

  TokenInterceptor(this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final data = err.response?.data;

      final message = data is Map<String, dynamic> ? data["message"] as String? : null;

      log('401 error message: $message');

      // 🔒 Device blocked holati
      if (message != null && message.contains("Device is blocked")) {
        final context = navigatorKey.currentContext;

        if (context != null) {
          final router = GoRouter.of(context);
          final location = router.routerDelegate.currentConfiguration.last.matchedLocation;

          if (location == CheckingPage.path) {
            return handler.next(err);
          } else {
            await DBService.clear();
            context.go(LoginPage.path);
            return handler.next(err);
          }
        }

      }

      // 🔑 Token expired bo‘lsa
      final refreshToken = DBService.refreshToken;

      if (refreshToken == null || refreshToken.isEmpty) {
        handler.next(err);
        return;
      }

      try {
        final response = await _dio.put(ApiUrls.renewAccess, data: {"refresh": refreshToken});
        final newAccess = response.data["access"];

        if (newAccess != null) {
          await DBService.saveTokens(newAccess, refreshToken);

          final retryRequest = await _dio.fetch(
            err.requestOptions..headers["Authorization"] = "Bearer $newAccess",
          );

          return handler.resolve(retryRequest);
        }
      } catch (e) {
        await DBService.clear();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }
}
