import 'dart:convert';

import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/api_services/configs/urls.dart';

import '../api_services/api_request/post_request.dart';
import '../api_services/configs/app_configs.dart';

class FareRulesRepository {
  final PostService postService = PostService();


  Future<String> fetchTboFareRulesHtml({
    required String source,
    required String traceId,
    required String? flightId,
    required String resultIndex,
  }) async {
    final customHeaders = {
      'action': 'TBO',
      'api-key': AppConfigs.apiKey,
    };
    final body = {
      "source": source,
      "traceId": traceId,
      "flightId": flightId,
      "ResultIndex": resultIndex,
    };


    try {
      final response = await postService.postRequest(
        endPoint: fareRulesUrl,
        body: body,
        requireAuth: false,
        customHeaders: customHeaders,
      );

      // Log the response for debugging
      AppLogger.log(jsonEncode(response));

      if (response['status'] == 'success') {
        final rules = response['data']['Response']['FareRules'] as List;
        return rules.isNotEmpty ? rules.first['FareRuleDetail'] as String : '';
      } else {
        final error = response['data']['Status']['Error'] ?? 'Unknown error';
        throw Exception("$error");
      }
    } catch (e) {

      throw '$e';  // Just throw the message
    }
  }

  Future<String> fetchAirIqFareRulesText({
    required List<String> flightIds,
    required String traceId,

  }) async {
    final customHeaders = {
      'action': 'AirIQ',
      'api-key': AppConfigs.apiKey,
    };
    final flightsInfo = flightIds.map((id) => {'FlightID': id}).toList();
    final body = {
      "FlightsInfo": flightsInfo,
      "Trackid": traceId,
    };
    try {
      final response = await postService.postRequest(
        endPoint: fareRulesUrl,
        body: body,
        requireAuth: false,
        customHeaders: customHeaders,
      );

      // Log the response for debugging
      AppLogger.log(jsonEncode(response));

      if (response['status'] == 'success') {
        final fareRuleInfo = response['data']['FareRuleInfo'];
        if (fareRuleInfo != null && fareRuleInfo['FareRuleText'] != null) {
          return fareRuleInfo['FareRuleText'] as String;
        }
        else {
          final error = response['data']['Status']['Error'] ?? 'Unknown error';
          throw Exception("$error");
        }
      } else {
        throw Exception(response['message'] ?? 'Unknown error occurred while fetching AirIQ fare rules.');
      }
    } catch (e) {
      throw '$e';
    }
  }

  Future<Map<String, dynamic>>  submitBooking(Map<String, dynamic> payload) async{
    final customHeaders = {
      'action' : 'Insert',
      'api-key' : AppConfigs.apiKey
    };

    final response = await postService.postRequest(
        endPoint: applicantDetailsUrl,
        body: payload,
        requireAuth: false,
        customHeaders: customHeaders
    );

    if(response['status'] == 'success'){
      return response;
    }else{
      throw Exception(response['message'] ?? "Unknown error occurred while booking.");
    }
  }

}
