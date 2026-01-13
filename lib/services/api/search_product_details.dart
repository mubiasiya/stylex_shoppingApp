import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  // Constructor with base configuration
  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'https://shopapp-server-dnq1.onrender.com', 
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    // Add Interceptors (Optional: Useful for logging or adding Auth Tokens)
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  // Generic GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST request
  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Professional Error Handling
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout with server";
      case DioExceptionType.badResponse:
        return "Server Error: ${error.response?.statusCode}";
      case DioExceptionType.connectionError:
        return "No Internet Connection";
      default:
        return "Something went wrong. Please try again.";
    }
  }
}
