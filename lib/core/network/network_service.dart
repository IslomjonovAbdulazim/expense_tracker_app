// lib/core/network/network_service.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../utils/constants/api_constants.dart';
import '../../utils/helpers/logger.dart';
import '../../utils/helpers/status_code_helper.dart';
import '../../utils/services/token_service.dart';
import '../../core/error/network_failure.dart';

class NetworkService extends GetxService {
  static NetworkService get to => Get.find<NetworkService>();

  late final dio.Dio _dio;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  // Add initialize method
  void initialize() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = dio.Dio(dio.BaseOptions(
      baseUrl: ApiConstants.baseURL,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _addInterceptors();
  }

  void _addInterceptors() {
    // Auth interceptor
    _dio.interceptors.add(dio.InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token if available
        if (Get.isRegistered<TokenService>()) {
          final token = TokenService.to.token;
          if (token.isNotEmpty) {
            options.headers['Authorization'] = token;
          }
        }

        Logger.log("REQUEST[${options.method}] => PATH: ${options.path}");
        handler.next(options);
      },

      onResponse: (response, handler) {
        Logger.log("RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}");
        handler.next(response);
      },

      onError: (error, handler) {
        Logger.error("ERROR[${error.response?.statusCode}] => ${error.message}");

        // Handle common HTTP errors
        _handleNetworkError(error);

        handler.next(error);
      },
    ));

    // Pretty logger for debug mode
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: true,
      ));
    }
  }

  void _handleNetworkError(dio.DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null) {
      StatusCodeService.showSnackbar(statusCode);

      // Handle authentication errors
      if (statusCode == 401 || statusCode == 403) {
        _handleAuthError();
      }
    }
  }

  void _handleAuthError() {
    // Clear token and redirect to login
    if (Get.isRegistered<TokenService>()) {
      TokenService.to.clearToken();
    }
    // Add navigation logic here
  }

  // Store active cancel tokens
  final List<dio.CancelToken> _activeCancelTokens = [];

  // Create a new cancel token for requests
  dio.CancelToken _createCancelToken() {
    final cancelToken = dio.CancelToken();
    _activeCancelTokens.add(cancelToken);
    return cancelToken;
  }

  // Clean up completed cancel tokens
  void _cleanupCancelToken(dio.CancelToken cancelToken) {
    _activeCancelTokens.remove(cancelToken);
  }

  // GET request with cancel token
  Future<Either<NetworkFailure, T>> get<T>(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) async {
    final token = cancelToken ?? _createCancelToken();

    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: token,
      );
      _cleanupCancelToken(token);
      return Right(response.data as T);
    } on dio.DioException catch (e) {
      _cleanupCancelToken(token);
      return Left(_handleDioException(e));
    } catch (e) {
      _cleanupCancelToken(token);
      return Left(NetworkFailure(
        message: 'Unexpected error: $e',
        statusCode: null,
      ));
    }
  }

  // POST request with cancel token
  Future<Either<NetworkFailure, T>> post<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) async {
    final token = cancelToken ?? _createCancelToken();

    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: token,
      );
      _cleanupCancelToken(token);
      return Right(response.data as T);
    } on dio.DioException catch (e) {
      _cleanupCancelToken(token);
      return Left(_handleDioException(e));
    } catch (e) {
      _cleanupCancelToken(token);
      return Left(NetworkFailure(
        message: 'Unexpected error: $e',
        statusCode: null,
      ));
    }
  }

  // PUT request with cancel token
  Future<Either<NetworkFailure, T>> put<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) async {
    final token = cancelToken ?? _createCancelToken();

    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: token,
      );
      _cleanupCancelToken(token);
      return Right(response.data as T);
    } on dio.DioException catch (e) {
      _cleanupCancelToken(token);
      return Left(_handleDioException(e));
    } catch (e) {
      _cleanupCancelToken(token);
      return Left(NetworkFailure(
        message: 'Unexpected error: $e',
        statusCode: null,
      ));
    }
  }

  // DELETE request with cancel token
  Future<Either<NetworkFailure, T>> delete<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) async {
    final token = cancelToken ?? _createCancelToken();

    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: token,
      );
      _cleanupCancelToken(token);
      return Right(response.data as T);
    } on dio.DioException catch (e) {
      _cleanupCancelToken(token);
      return Left(_handleDioException(e));
    } catch (e) {
      _cleanupCancelToken(token);
      return Left(NetworkFailure(
        message: 'Unexpected error: $e',
        statusCode: null,
      ));
    }
  }

  // File upload with cancel token
  Future<Either<NetworkFailure, T>> uploadFile<T>(
      String endpoint,
      String filePath, {
        String fieldName = 'file',
        Map<String, dynamic>? additionalData,
        dio.ProgressCallback? onSendProgress,
        dio.CancelToken? cancelToken,
      }) async {
    final token = cancelToken ?? _createCancelToken();

    try {
      final formData = dio.FormData.fromMap({
        fieldName: await dio.MultipartFile.fromFile(filePath),
        ...?additionalData,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: token,
      );

      _cleanupCancelToken(token);
      return Right(response.data as T);
    } on dio.DioException catch (e) {
      _cleanupCancelToken(token);
      return Left(_handleDioException(e));
    } catch (e) {
      _cleanupCancelToken(token);
      return Left(NetworkFailure(
        message: 'Upload failed: $e',
        statusCode: null,
      ));
    }
  }

  NetworkFailure _handleDioException(dio.DioException e) {
    String message;

    switch (e.type) {
      case dio.DioExceptionType.connectionTimeout:
        message = 'Connection timeout';
        break;
      case dio.DioExceptionType.sendTimeout:
        message = 'Send timeout';
        break;
      case dio.DioExceptionType.receiveTimeout:
        message = 'Receive timeout';
        break;
      case dio.DioExceptionType.badResponse:
        message = e.response?.data?['message'] ?? 'Server error';
        break;
      case dio.DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      case dio.DioExceptionType.connectionError:
        message = 'Connection error';
        break;
      default:
        message = e.message ?? 'Unknown error';
    }

    return NetworkFailure(
      message: message,
      statusCode: e.response?.statusCode,
    );
  }

  // Cancel all active requests
  void cancelAllRequests() {
    for (final token in _activeCancelTokens) {
      if (!token.isCancelled) {
        token.cancel('All requests cancelled');
      }
    }
    _activeCancelTokens.clear();
  }

  // Cancel specific request by cancel token
  void cancelRequest(dio.CancelToken cancelToken) {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel('Request cancelled by user');
    }
    _cleanupCancelToken(cancelToken);
  }

  @override
  void onClose() {
    // Cancel all requests when service is disposed
    cancelAllRequests();
    super.onClose();
  }
}