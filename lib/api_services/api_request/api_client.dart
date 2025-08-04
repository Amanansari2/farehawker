import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';

import '../configs/urls.dart';

class DioApiClient {
  final Dio _dio;
  final GetStorage box = GetStorage();
  bool _hasLoggedOut = false;

  DioApiClient()
      : _dio = Dio(BaseOptions(
    baseUrl: apiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  )) {
    if (kDebugMode) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      _dio.interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        error: true,
      ));
    }

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = box.read('auth_token');
        if (token != null && options.headers['Authorization'] == null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        if (e.response?.statusCode == 401) {
          _handleUnauthorized();
        }
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParams,
        Map<String, String>? headers,
        bool requiresAuth = false}) async {
    final options = _buildOptions(headers, requiresAuth);
    return _dio.get(path, queryParameters: queryParams, options: options);
  }

  Future<Response> post(String path, dynamic data,
      {Map<String, String>? headers, bool requiresAuth = false}) async {
    final options = _buildOptions(headers, requiresAuth);
    return _dio.post(path, data: data, options: options);
  }

  Future<Response> put(String path, dynamic data,
      {Map<String, String>? headers, bool requiresAuth = false}) async {
    final options = _buildOptions(headers, requiresAuth);
    return _dio.put(path, data: data, options: options);
  }

  Future<Response> delete(String path,
      {Map<String, String>? headers, bool requiresAuth = false}) async {
    final options = _buildOptions(headers, requiresAuth);
    return _dio.delete(path, options: options);
  }

  Options _buildOptions(Map<String, String>? headers, bool requiresAuth) {
    final allHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = box.read('auth_token');
      if (token != null) {
        allHeaders['Authorization'] = 'Bearer $token';
      } else {
        _handleUnauthorized();
        throw Exception('Authentication required');
      }
    }

    if (headers != null) {
      allHeaders.addAll(headers);
    }

    return Options(headers: allHeaders);
  }

  void _handleUnauthorized() {
    if (_hasLoggedOut) return;
    _hasLoggedOut = true;
    box.remove('auth_token');
    // Get.offAllNamed(AppRoutes.loginView);
  }

  void dispose() {
    _dio.close(force: true);
  }
}
