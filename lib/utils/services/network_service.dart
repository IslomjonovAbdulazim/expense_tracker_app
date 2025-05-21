// lib/data/services/network_service.dart
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:expense_tracker_app/utils/services/token_service.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../core/error/network_failure.dart';
import '../constants/api_constants.dart';
import '../helpers/logger.dart';

class NetworkService {
  static NetworkService get instance => _instance;
  static final NetworkService _instance = NetworkService._internal();

  late final Dio _dio;

  // Private constructor
  NetworkService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseURL,
        contentType: 'application/json',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // Add interceptors
    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Only add logger in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ));
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          final tokenService = TokenService.to;
          if (tokenService.hasToken) {
            options.headers['Authorization'] = tokenService.token;
          }

          options.headers['accept'] = '*/*';
          Logger.log("REQUEST[${options.method}] => PATH: ${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          Logger.log("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          Logger.error("ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}");

          // Handle auth errors
          if (e.response?.statusCode == 401) {
            // Handle token expiration or auth issues
            debugPrint('Authorization error: ${e.message}');
          }

          return handler.next(e);
        },
      ),
    );
  }

  /// Performs a GET request and returns an Either with a NetworkFailure or the response data.
  Future<Either<NetworkFailure, T>> get<T>(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(NetworkFailure(
        message: e.toString(),
        statusCode: 0,
      ));
    }
  }

  /// Performs a POST request and returns an Either with a NetworkFailure or the response data.
  Future<Either<NetworkFailure, T>> post<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(NetworkFailure(
        message: e.toString(),
        statusCode: 0,
      ));
    }
  }

  /// Performs a PUT request and returns an Either with a NetworkFailure or the response data.
  Future<Either<NetworkFailure, T>> put<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(NetworkFailure(
        message: e.toString(),
        statusCode: 0,
      ));
    }
  }

  /// Performs a DELETE request and returns an Either with a NetworkFailure or the response data.
  Future<Either<NetworkFailure, T>> delete<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(NetworkFailure(
        message: e.toString(),
        statusCode: 0,
      ));
    }
  }

  /// Helper method to handle DioExceptions
  NetworkFailure _handleError(DioException e) {
    Logger.error("Dio error: ${e.message}");
    return NetworkFailure(
      message: e.message ?? "Network error",
      statusCode: e.response?.statusCode,
    );
  }
}

// HTTP override for self-signed certificates
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}