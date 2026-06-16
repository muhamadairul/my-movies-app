import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

/// Singleton Dio client dengan konfigurasi global.
/// Menangani timeout, interceptors, dan error handling dasar.
class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late final Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: ApiConstants.headers,
      ),
    );

    // Logging interceptor untuk debugging
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('➡️ REQUEST: ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint('❌ ERROR: ${e.type} - ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }
}

void debugPrint(String message) {
  // ignore: avoid_print
  print(message);
}
