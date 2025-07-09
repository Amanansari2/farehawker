// import 'dart:convert';
//
// import 'package:dio/dio.dart';
// import 'package:flightbooking/api_services/app_logger.dart';
// import 'package:get_storage/get_storage.dart';
//
// import '../api_services/configs/urls.dart';
//
// class AuthRepository{
//   final Dio _dio = Dio();
//   final box = GetStorage('authBox');
//
//   Future<bool> loginIfNeeded() async {
//     final token = box.read('auth_token');
//     final timestamp = box.read('auth_token_timestamp');
//
//     AppLogger.log("Stored token: $token");
//     AppLogger.log("Stored timestamp: $timestamp");
//
//     if(token != null && timestamp != null){
//       final saved = DateTime.parse(timestamp);
//       final hoursDiff = DateTime.now().difference(saved).inHours;
//       AppLogger.log("Token age: $hoursDiff hours");
//       if(hoursDiff < 24) {
//         AppLogger.log("✅ Token still valid, skipping login.");
//         return true;
//       }
//     }
//
//     AppLogger.log("Token missing or expired. Proceeding to login...");
//     return await _login();
//   }
//
//   Future<bool> _login() async {
//     try{
//       const agentId = 'AQAG011766';
//       const username = '9311663434';
//       const password = '9311663434';
//       final credentials = "$agentId*$username:$password";
//       final auth = base64Encode(utf8.encode(credentials));
//       final authHeader = 'Basic $auth';
//
//       final response = await _dio.post(
//           authUrl,
//         options: Options(headers: {'Authorization' : authHeader}),
//       );
//
//       AppLogger.log("Initial Response  --->>>> $response");
//
//       final token = response.data['token'];
//       if (token != null) {
//         box.write('auth_token', token);
//         box.write('auth_token_timestamp', DateTime.now().toIso8601String());
//         return true;
//       }
//     } catch (e) {
//       AppLogger.log("Login error: $e");
//     }
//     return false;
//   }
//     }
