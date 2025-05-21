// lib/data/providers/dio_manager.dart
import 'dart:io';

// Import Dio with a specific prefix to avoid naming conflicts
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:get/get.dart';

import '../../utils/constants/api_constants.dart';

// Create a Dio singleton instance
final dio.Dio dioInstance = dio.Dio(
  dio.BaseOptions(
    baseUrl: ApiConstants.baseURL,
    contentType: 'application/json',
  ),
);

// Configure Dio with interceptors and settings
void configureDio() {
  try {
    // Add logging in debug mode
    if (kDebugMode) {
      dioInstance.interceptors.add(DioInterceptor());
      dioInstance.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          responseBody: true,
          compact: true,
        ),
      );
    }

    // Register the Dio instance with GetX for dependency injection
    if (!Get.isRegistered<dio.Dio>()) {
      Get.put(dioInstance, permanent: true);
    }

    debugPrint("Dio configured successfully");
  } catch (e) {
    debugPrint("Error configuring Dio: $e");
  }
}

// Custom interceptor for Dio
class DioInterceptor extends dio.Interceptor {
  @override
  void onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    // Add any request headers here
    options.headers['accept'] = '*/*';

    // Add authorization token if available
    // if (TokenService.to.hasToken) {
    //   options.headers['Authorization'] = 'Bearer ${TokenService.to.token}';
    // }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(dio.Response response, dio.ResponseInterceptorHandler handler) {
    debugPrint('Response received: ${response.statusCode}');
    super.onResponse(response, handler);
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    debugPrint('Dio error: ${err.type} - ${err.response?.statusCode}');

    // Handle authentication errors
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      debugPrint('Authentication error occurred');
      // Handle authentication error (logout, refresh token, etc.)
    }

    super.onError(err, handler);
  }
}

// HTTP override for accepting self-signed certificates (for development)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}