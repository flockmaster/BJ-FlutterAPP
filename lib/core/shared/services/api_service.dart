import 'package:dio/dio.dart';
import 'package:car_owner_app/core/constants/app_constants.dart';
import 'package:car_owner_app/core/config/app_config.dart';
import 'storage_service.dart';

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;
  final dynamic details;

  ApiException({
    required this.message,
    this.code,
    this.statusCode,
    this.details,
  });

  @override
  String toString() => message;

  /// Create from DioException
  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: '网络连接超时，请检查网络后重试',
          code: 'TIMEOUT',
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: '网络连接失败，请检查网络设置',
          code: 'CONNECTION_ERROR',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        String message = '请求失败';
        String? code;
        
        if (data is Map) {
          message = data['error']?['message'] ?? data['message'] ?? message;
          code = data['error']?['code'] ?? data['code'];
        }
        
        if (statusCode == 401) {
          message = '登录已过期，请重新登录';
          code = 'UNAUTHORIZED';
        } else if (statusCode == 403) {
          message = '没有权限访问';
          code = 'FORBIDDEN';
        } else if (statusCode == 404) {
          message = '请求的资源不存在';
          code = 'NOT_FOUND';
        } else if (statusCode != null && statusCode >= 500) {
          message = '服务器错误，请稍后重试';
          code = 'SERVER_ERROR';
        }
        
        return ApiException(
          message: message,
          code: code,
          statusCode: statusCode,
          details: data,
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: '请求已取消',
          code: 'CANCELLED',
        );
      default:
        return ApiException(
          message: '网络请求失败',
          code: 'UNKNOWN',
        );
    }
  }
}

/// API response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? errorCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.errorCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJson,
  ) {
    return ApiResponse(
      success: json['success'] ?? true,
      data: fromJson != null && json['data'] != null
          ? fromJson(json['data'])
          : json['data'],
      message: json['message'],
      errorCode: json['error']?['code'],
    );
  }
}

/// API Service for network requests
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;
  StorageService? _storageService;
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  void initialize({StorageService? storageService}) {
    _storageService = storageService;
    
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.requestTimeout,
      receiveTimeout: AppConstants.requestTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token if available
        final token = _storageService?.getUserToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 errors - clear token
        if (error.response?.statusCode == 401) {
          await _storageService?.clearUserSession();
        }
        handler.next(error);
      },
    ));

    // Add logging interceptor in debug mode
    if (AppConfig.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[API] $obj'),
      ));
    }
  }

  Dio get dio => _dio;

  /// Set auth token
  void setAuthToken(String token) {
    _storageService?.saveUserToken(token);
  }

  /// Clear auth token
  void clearAuthToken() {
    _storageService?.removeUserToken();
  }

  /// GET request with retry support
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool retry = true,
  }) async {
    return _executeWithRetry(
      () => _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      ),
      retry: retry,
    );
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Execute request with retry logic
  Future<Response<T>> _executeWithRetry<T>(
    Future<Response<T>> Function() request, {
    bool retry = true,
    int retryCount = 0,
  }) async {
    try {
      return await request();
    } on DioException catch (e) {
      if (retry && _shouldRetry(e) && retryCount < maxRetries - 1) {
        await Future.delayed(retryDelay * (retryCount + 1));
        return _executeWithRetry(
          request,
          retry: retry,
          retryCount: retryCount + 1,
        );
      }
      throw ApiException.fromDioException(e);
    }
  }

  /// Check if request should be retried
  bool _shouldRetry(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        (e.response?.statusCode ?? 0) >= 500;
  }
}