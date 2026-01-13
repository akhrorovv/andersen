import 'dart:developer';

import 'package:andersen/core/api/api_urls.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/navigation/app_router.dart';
import 'package:andersen/core/network/network_error_handler.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/auth/presentation/pages/checking_page.dart';
import 'package:andersen/features/auth/presentation/pages/login_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
    // Skip if it's a network error - don't process auth logic
    if (_isNetworkError(err)) {
      return handler.next(err);
    }

    final status = err.response?.statusCode;
    final data = err.response?.data;

    final message = data is Map<String, dynamic> ? data["message"] as String? : null;
    log('${status ?? "?"} error message: $message');

    // 🧩 Device error (401 & 404)
    if ((status == 401 || status == 404) && message != null) {
      final context = navigatorKey.currentContext;

      if (message.contains("Device is blocked")) {
        // 🚫 Device is blocked
        if (context != null) {
          context.go(CheckingPage.path);
        }
        return handler.next(err);
      }

      if (message.contains("Device not found")) {
        // ❌ Device not found
        if (context != null) {
          await DBService.clear();
          context.go(LoginPage.path);
        }
        return handler.next(err);
      }
    }

    // 🔑 Token expired (401)
    if (status == 401) {
      final refreshToken = DBService.refreshToken;

      if (refreshToken == null || refreshToken.isEmpty) {
        return handler.next(err);
      }

      try {
        final response = await _dio.put(
          ApiUrls.renewAccess,
          data: {"refresh": refreshToken},
        );
        final newAccess = response.data["access"];

        if (newAccess != null) {
          await DBService.saveTokens(newAccess, refreshToken);

          final retryRequest = await _dio.fetch(
            err.requestOptions..headers["Authorization"] = "Bearer $newAccess",
          );

          return handler.resolve(retryRequest);
        }
      } on DioException catch (e) {
        // If refresh fails due to network error, don't clear credentials
        if (_isNetworkError(e)) {
          return handler.next(err);
        }
        await DBService.clear();
        return handler.next(err);
      } catch (e) {
        await DBService.clear();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  bool _isNetworkError(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.error is NetworkException;
  }
}

class ConnectivityInterceptor extends Interceptor {
  final Connectivity _connectivity;

  ConnectivityInterceptor({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final result = await _connectivity.checkConnectivity();

    if (result.contains(ConnectivityResult.none)) {
      // Show global network error overlay
      NetworkErrorHandler.instance.showError();

      handler.reject(
        DioException(
          requestOptions: options,
          error: NetworkException(),
          type: DioExceptionType.connectionError,
        ),
      );
      return;
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Convert timeout and connection errors to NetworkException
    if (_isNetworkError(err)) {
      // Show global network error overlay
      NetworkErrorHandler.instance.showError();

      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkException(message: _getNetworkErrorMessage(err)),
          type: DioExceptionType.connectionError,
          response: err.response,
        ),
      );
      return;
    }
    handler.next(err);
  }

  bool _isNetworkError(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.error is NetworkException;
  }

  String _getNetworkErrorMessage(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.connectionError:
        return 'Connection error';
      default:
        return 'No internet connection';
    }
  }
}
