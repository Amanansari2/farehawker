// import 'dart:convert';
//
// import 'package:dio/dio.dart';
// import 'package:flightbooking/api_services/app_logger.dart';
// import 'package:get_storage/get_storage.dart';
// import '../logging_service.dart';
// import '../configs/urls.dart';
//
// class PostService {
//   final Dio _dio;
//   final GetStorage _box = GetStorage();
//
//   PostService()
//       : _dio = Dio(BaseOptions(
//     baseUrl: apiBaseUrl,
//     connectTimeout: const Duration(seconds: 15),
//     receiveTimeout: const Duration(seconds: 30),
//     headers: {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     },
//   ));
//
//   Future<Map<String, dynamic>> postRequest({
//     required String endPoint,
//     required Map<String, dynamic> body,
//     bool requireAuth = false,
//     Map<String, String>? customHeaders,
//   }) async {
//     final headers = <String, String>{
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };
//
//     if (requireAuth) {
//       final token = _box.read("auth_token");
//       if (token != null) {
//         headers["Authorization"] = "Bearer $token";
//       }
//     }
//
//     if (customHeaders != null) {
//       headers.addAll(customHeaders);
//     }
//
//     LoggerService.logRequest(url: endPoint, headers: headers, body: body);
//
//
//     try {
//       final response = await _dio.post(
//         endPoint,
//         data: body,
//         options: Options(
//             headers: headers,
//             responseType: ResponseType.plain,
//         ),
//       );
//
//       LoggerService.logDioResponse(response);
//       return json.decode(response.data);
//
//     }
//
//     catch (e) {
//       final res = (e is DioException) ? e.response : null;
//       final status = res?.statusCode ?? 500;
//       final raw = res?.data;
//
//       AppLogger.log("ERROR Code -->> $status");
//       AppLogger.log("Error Data -->> $raw");
//
//       return json.decode(raw);
//
//
//       if (e is DioException) {
//         final status = e.response?.statusCode ?? 500;
//         final raw = e.response?.data;
//
//         AppLogger.log("ERROR Code -->> $status");
//         AppLogger.log("Error Data -->> $raw");
//
//         if (raw != null && raw is String) {
//           try {
//             return jsonDecode(raw) as Map<String, dynamic>;
//           } catch (_) {
//             return {
//               'status': 'error',
//               'code': status,
//               'message': 'Error body not in JSON format',
//               'raw': raw.toString(),
//             };
//           }
//         } else {
//           return {
//             'status': 'error',
//             'code': status,
//             'message': 'No response body returned from server',
//           };
//         }
//       } else {
//         AppLogger.log("🔥 Unexpected exception: $e");
//         return {
//           'status': 'error',
//           'code': 500,
//           'message': e.toString(),
//         };
//       }
//     }
//
//
//   }
//
// }
//
//


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
      : _dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 120),
      headers: {
        'Content-Type': 'application/json',

      },
    ),
  );

  Future<Map<String, dynamic>> postRequest({
    required String endPoint,
    required Map<String, dynamic> body,
    bool requireAuth = false,
    Map<String, String>? customHeaders,
  }) async {

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (requireAuth) {
      final token = _box.read("auth_token");
      if (token != null && token.toString().isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }


    body.removeWhere((_, value) => value == null);



    LoggerService.logRequest(url: endPoint, headers: headers, body: body);

    try {
      final response = await _dio.post(
        endPoint,
        data: jsonEncode(body),
        options: Options(
          headers: headers,
          responseType: ResponseType.plain,
        ),
      );

      LoggerService.logDioResponse(response);

      if (response.data == null) {
        return {
          'status': 'error',
          'code': response.statusCode ?? 500,
          'message': 'Empty response body',
        };
      }

      if (response.data is String) {
        try {
          return jsonDecode(response.data) as Map<String, dynamic>;
        } catch (_) {
          return {
            'status': 'error',
            'code': response.statusCode ?? 500,
            'message': 'Non-JSON response',
            'raw': response.data,
          };
        }
      }

      if (response.data is Map<String, dynamic>) {
        return response.data;
      }

      return {
        'status': 'error',
        'code': response.statusCode ?? 500,
        'message': 'Unexpected response type',
        'raw': response.data.toString(),
      };
    } on DioException catch (e) {
      final status = e.response?.statusCode ?? 500;
      final raw = e.response?.data;

      AppLogger.log(" DioException: $e");
      AppLogger.log(" Status: $status");
      AppLogger.log(" Raw data: $raw");

      if (raw == null) {
        return {
          'status': 'error',
          'code': status,
          'message': 'No response body returned from server',
        };
      }

      if (raw is String) {
        try {
          return jsonDecode(raw) as Map<String, dynamic>;
        } catch (_) {
          return {
            'status': 'error',
            'code': status,
            'message': 'Error body not JSON',
            'raw': raw,
          };
        }
      }

      if (raw is Map<String, dynamic>) {
        return raw;
      }

      return {
        'status': 'error',
        'code': status,
        'message': 'Unexpected error body type',
        'raw': raw.toString(),
      };
    } catch (e) {
      AppLogger.log("🔥 Unexpected exception: $e");
      return {
        'status': 'error',
        'code': 500,
        'message': e.toString(),
      };
    }
  }


}
