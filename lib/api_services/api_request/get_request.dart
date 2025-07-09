import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../logging_service.dart';
import '../configs/urls.dart';

class GetService {
  final Dio _dio;
  final GetStorage _box = GetStorage();

  GetService()
      : _dio = Dio(BaseOptions(
    baseUrl: apiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  Future<Map<String, dynamic>> getRequest({
    required String endPoint,
    bool requireAuth = false,
    Map<String, String>? customHeaders,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final token = _box.read("auth_token");
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    LoggerService.logRequest(
      url: endPoint,
      headers: headers,
      body: {},
    );

    try {
      final response = await _dio.get(
        endPoint,
        options: Options(headers: headers),
      );

      LoggerService.logDioResponse(response);
      return response.data is Map<String, dynamic>
          ? response.data
          : {'response': response.data};
    } on DioException catch (e) {
      LoggerService.logWarning("Dio Error --->>> ${e.message}");
      if (e.response != null)  LoggerService.logDioResponse(e.response!);
      return {
        'error': e.message,
        'status': e.response?.statusCode ?? 500,
        'response': e.response?.data,
      };
    } catch (e) {
      LoggerService.logWarning("Unexpected Error --->>> $e");
      return {'error': e.toString(), 'status': 500};
    }
  }

}
