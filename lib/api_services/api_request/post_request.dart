import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flightbooking/api_services/app_logger.dart';
import 'package:get_storage/get_storage.dart';
import '../logging_service.dart';
import '../configs/urls.dart';

class PostService {
  final Dio _dio;
  final GetStorage _box = GetStorage();

  PostService()
      : _dio = Dio(BaseOptions(
    baseUrl: apiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  Future<Map<String, dynamic>> postRequest({
    required String endPoint,
    required Map<String, dynamic> body,
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

    LoggerService.logRequest(url: endPoint, headers: headers, body: body);


    try {
      final response = await _dio.post(
        endPoint,
        data: body,
        options: Options(
            headers: headers,
            responseType: ResponseType.plain,
        ),
      );

      LoggerService.logDioResponse(response);
      return json.decode(response.data);

    }

    catch (e) {
      final res = (e is DioException) ? e.response : null;
      final status = res?.statusCode ?? 500;
      final raw = res?.data;

      AppLogger.log("ERROR Code -->> $status");
      AppLogger.log("Error Data -->> $raw");

      return json.decode(raw);
    }



  }

}


