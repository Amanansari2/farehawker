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
      'action': 'GetFareRule',
      'api-key': AppConfigs.apiKey,
    };
    final body = {
      "source": source,
      "traceId": traceId,
      "flightId": flightId,
      "ResultIndex": resultIndex,
    };

    final response = await postService.postRequest(
      endPoint: flightSearch,
      body: body,
      requireAuth: false,
      customHeaders: customHeaders
    );

    if (response['status'] == 'success') {
      final rules = response['data']['Response']['FareRules'] as List;
      return rules.isNotEmpty ? rules.first['FareRuleDetail'] as String : '';
    }
    throw Exception(response['message'] ?? 'Unknown error');
  }

  Future<String> fetchAirIqFareRulesText({
    required String source,
    required String traceId,
    required String? flightId,
    required String resultIndex,
  }) async {
    final customHeaders = {
      'action': 'GetFareRule',
      'api-key': AppConfigs.apiKey,
    };
    final body = {
      "source": source,
      "traceId": traceId,
      "flightId": flightId,
      "ResultIndex": resultIndex,
    };

    final response = await postService.postRequest(
      endPoint: flightSearch,
      body: body,
      requireAuth: false,
      customHeaders: customHeaders  );

    if (response['status'] == 'success') {
      return response['data']['FareRuleInfo']['FareRuleText'] as String;
    }
    throw Exception(response['message'] ?? 'Unknown error');
  }

  Future<Map<String, dynamic>>  submitBooking(Map<String, dynamic> payload) async{
    final customHeaders = {
      'action' : 'InsertApplicantDetails',
      'api-key' : AppConfigs.apiKey
    };

    final response = await postService.postRequest(
        endPoint: flightSearch,
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
