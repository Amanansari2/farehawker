import 'dart:convert';

import 'package:flightbooking/api_services/api_request/post_request.dart';
import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/api_services/configs/app_configs.dart';
import 'package:flightbooking/api_services/configs/urls.dart';

class PolicyRepository{
  final PostService postService = PostService();
  
  Future<String> fetchTermsCondition() async{
    try{
      final response = await postService.postRequest(
          endPoint: termsCondition, 
          body: {},
        requireAuth: false,
        customHeaders: {
          'action': 'TermsandConditions',
          'api-key' : AppConfigs.apiKey
        }
      );
      AppLogger.log(jsonEncode(response));
      if(response['status'] == 'success'){
        return response['data'].toString();
      }else{
        throw Exception(response['message']);
      }
    }catch(e, stackTrace){
      AppLogger.log("Error fetching terms : $e\n$stackTrace");
      throw Exception(e.toString());
    }
  }

  Future<String> fetchPrivacyPolicy() async {
    try{
      final response = await postService.postRequest(
          endPoint: privacyPolicy,
          body: {},
          requireAuth: false,
        customHeaders: {
          'action': 'PrivacyPolicy',
          'api-key' : AppConfigs.apiKey
        }
      );
      AppLogger.log(jsonEncode(response));
      if(response['status'] == 'success'){
        return response['data'].toString();
      } else{
        throw Exception(response['message']);
      }
    }catch(e, stackTrace){
      AppLogger.log("Error fetching privacy : $e\n$stackTrace");
      throw Exception(e.toString());
    }
  }

  Future<String> fetchRefundPolicy() async {
    try{
      final response = await postService.postRequest(
          endPoint: refundPolicy,
          body: {},
      requireAuth: false,
      customHeaders: {
        'action': 'RefundPolicy',
        'api-key' : AppConfigs.apiKey
      }
      );
      AppLogger.log(jsonEncode(response));
      if(response['status'] == 'success'){
       return response['data'].toString();
      }else{
        throw Exception(response['message']);
      }
    }catch(e, stackTrace){
      AppLogger.log("Error fetching refund : $e\n$stackTrace");
      throw Exception(e.toString());
    }
  }
}