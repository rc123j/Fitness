import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'api_endpoints.dart';
import 'auth_service.dart';

class ApiClient extends GetxService {
  late Dio _dio;
  late AuthService _authService;

  Future<ApiClient> init() async {
    _authService = Get.find<AuthService>();

    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'bypass-tunnel-reminder': 'true',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _authService.accessToken;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshed = await _tryRefreshToken();
          if (refreshed) {
            final retryOptions = error.requestOptions;
            retryOptions.headers['Authorization'] =
                'Bearer ${_authService.accessToken}';
            try {
              final response = await _dio.fetch(retryOptions);
              handler.resolve(response);
              return;
            } catch (_) {}
          }
        }
        handler.next(error);
      },
    ));

    return this;
  }

  Future<bool> _tryRefreshToken() async {
    final refreshToken = _authService.refreshToken;
    if (refreshToken == null) return false;

    try {
      final response = await Dio(BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: {
          'Content-Type': 'application/json',
          'bypass-tunnel-reminder': 'true',
        },
      )).post(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        _authService.updateAccessToken(response.data['accessToken']);
        return true;
      }
    } on DioException catch (_) {
      return false;
    } catch (_) {}

    return false;
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) {
    return _dio.get(path, queryParameters: queryParams);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}
