import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../../utils/constants/api_constants.dart';
import '../../utils/services/token_service.dart';

class DioManager {
  static final DioManager _instance = DioManager._internal();
  late final Dio dio;

  factory DioManager() => _instance;

  DioManager._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseURL,
        contentType: 'application/json',
      ),
    );
    _configureInterceptors();
  }

  void _configureInterceptors() {
    // Add auth token interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = TokenService.to.token;
          if (token.isNotEmpty) {
            options.headers['Authorization'] = token;
          }
          options.headers['accept'] = '*/*';
          return handler.next(options);
        },
      ),
    );

    // Add logging in debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          responseBody: true,
          compact: true,
        ),
      );
    }

    // Add error handling interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException err, handler) {
          debugPrint('API Error: ${err.message}');
          // Handle specific status codes
          if (err.response?.statusCode == 401) {
            // Handle unauthorized - could refresh token or logout
          }
          return handler.next(err);
        },
      ),
    );
  }

  // Configure certificate verification bypass for dev environments
  static void configureHttpOverrides() {
    if (!kReleaseMode) {
      HttpOverrides.global = MyHttpOverrides();
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, __, ___) => !kReleaseMode;
  }
}