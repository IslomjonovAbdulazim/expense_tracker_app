import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/error/network_failure.dart';
import '../constants/app_constants.dart';
import '../helpers/logger.dart';

class NetworkService {
  late final Dio _dio;

  NetworkService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: AppConstants.timeoutSeconds),
        receiveTimeout: const Duration(seconds: AppConstants.timeoutSeconds),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          Logger.log("REQUEST[${options.method}] => PATH: ${options.path}");
          handler.next(options);
        },
        onResponse: (response, handler) {
          Logger.log("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
          handler.next(response);
        },
        onError: (DioException e, handler) {
          Logger.error("ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}");
          handler.next(e);
        },
      ),
    );
  }

  // Generic HTTP request method to reduce code duplication
  Future<Either<NetworkFailure, T>> _request<T>({
    required String method,
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.request(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
      );
      return Right(response.data as T);
    } on DioException catch (e) {
      Logger.error("Dio $method error: ${e.message}");
      return Left(NetworkFailure(
        message: e.message ?? "Error",
        statusCode: e.response?.statusCode,
      ));
    }
  }

  // Public methods using the generic request method
  Future<Either<NetworkFailure, T>> get<T>(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      }) =>
      _request<T>(
          method: 'GET',
          endpoint: endpoint,
          queryParameters: queryParameters
      );

  Future<Either<NetworkFailure, T>> post<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) =>
      _request<T>(
          method: 'POST',
          endpoint: endpoint,
          data: data,
          queryParameters: queryParameters
      );

  Future<Either<NetworkFailure, T>> put<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) =>
      _request<T>(
          method: 'PUT',
          endpoint: endpoint,
          data: data,
          queryParameters: queryParameters
      );

  Future<Either<NetworkFailure, T>> delete<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) =>
      _request<T>(
          method: 'DELETE',
          endpoint: endpoint,
          data: data,
          queryParameters: queryParameters
      );
}