import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'app_logger.dart';

class LoggerService {
  static void logRequest({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String> headers,
  }) {
    AppLogger.log("Post Url----->>>> $url");
    AppLogger.log("Headers----->>>> $headers");
    AppLogger.log("Post Body----->>>> $body");
  }

  static void logDioResponse(Response response) {
    AppLogger.log(
        "Api Response ---->>> Status code [${response.statusCode}]: url-->>> ${response.realUri}");
    AppLogger.log(
      "Api Response Body --->>>> ${response.data}",
    );
  }

  static void logWarning(String message) {
    AppLogger.log("Warning---->>> $message");
  }
}
