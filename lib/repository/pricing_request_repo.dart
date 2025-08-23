import 'package:flightbooking/api_services/api_request/post_request.dart';
import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/api_services/configs/urls.dart';
import 'package:flightbooking/models/pricing_rules_model/one_way_pricing_request_model.dart';

import '../api_services/configs/app_configs.dart';

class PricingRepository{

  final PostService postService = PostService();

  Future<Map<String, dynamic>> oneWayPricing(PricingPayload payload)async {
    try{
      final response = await postService.postRequest(
          endPoint: oneWayPricingRule,
          body: payload.toJson(),
          customHeaders: {
            'action': 'Pricing',
            'api-key': AppConfigs.apiKey,
          },
        requireAuth: false
      );
          return response;
    } catch(e){
      AppLogger.log("Exception during getting pricing $e");
      return {
        'status': 'error',
        'code': 500,
        'message': e.toString(),
      };
    }
  }
}