import 'package:flightbooking/api_services/api_request/post_request.dart';
import 'package:flightbooking/api_services/configs/app_configs.dart';
import 'package:flightbooking/api_services/configs/urls.dart';
import 'package:flightbooking/models/flight_details_model.dart';

import '../api_services/app_logger.dart';

class SearchFlightRepository {
  final PostService _postService = PostService();

  Future<Map<String, dynamic>> searchFlight({
    required String from,
    required String to,
    required String date,
    required String adult,
    required String child,
    required String infant,
    int page = 1,
    int limit = 10,
    String? stopOption,
    String? refundableOption,
    String? departureTime,
    String? selectedAirlines,
    String? classOptions,
})async {
    final customHeaders = {
      'action': 'getAllSortedFares',
      'api-key': AppConfigs.apiKey,
    };
    final body = {
      "TripType": "O",
      "AirlineID": null,
      "DepartureStation": from,
      "ArrivalStation": to,
      "FlightDate": date,
      "roundDate" : null,
      "selectedTimeSlot" : departureTime,
      "FarecabinOption": classOptions ?? "Economy",
      "FareType": null,
      "OnlyDirectFlight": stopOption,
      "AdultCount": adult,
      "ChildCount": child,
      "InfantCount": infant,
      "selectedAirlines" : selectedAirlines,
      "refundFilter" : refundableOption
    };

    final response =  await _postService.postRequest(
        endPoint: '$flightSearch?page=$page&limit=$limit',
        body: body,
        requireAuth:  false,
        customHeaders: customHeaders
    );

    if(response['status'] == 'success'){
      final flightResponse =  FlightResponse.fromJson(response);
      return {
        'success' : true,
        'data' : flightResponse,
        // 'data': {
        //   'onward_detail': response['data']['onward_detail'],
        //   'return_detail': response['data']['return_detail'],
        //   'available_airlines' : response['data']['available_airlines']
        //
        // },
        'pagination': response['pagination'],
      };
    } else {
      return {
        'success': false,
        'message': response['message'],
        'code': response['code'] ?? response['status'] ?? 500,
      };
    }
  }


  Future<Map<String,dynamic>> searchRoundFlight({
    required String from,
    required String to,
    required String date,
    required String returnDate,
    required String adult,
    required String child,
    required String infant,
    int page = 1,
    int limit = 10,
    int pageR = 1,
    int limitR = 10,
    String? stopOption,
    String? refundableOption,
    String? departureTime,
    String? selectedAirlines,
    String? classOptions,
}) async {
    final customHeaders = {
      'action': 'getAllSortedFares',
      'api-key': AppConfigs.apiKey,
    };
    final body = {
      "TripType": "r",
      "AirlineID": null,
      "DepartureStation": from,
      "ArrivalStation": to,
      "FlightDate": date,
      "roundDate" : returnDate,
      "selectedTimeSlot" : departureTime,
      "FarecabinOption": classOptions ?? "Economy",
      "FareType": null,
      "OnlyDirectFlight": stopOption,
      "AdultCount": int.tryParse(adult) ?? 0,
      "ChildCount": int.tryParse(child) ?? 0,
      "InfantCount": int.tryParse(infant) ?? 0,
      "selectedAirlines" : selectedAirlines,
      "refundFilter" : refundableOption
    };
    try {
      final response = await _postService.postRequest(
          endPoint: '$flightSearch?page=$page&limit=$limit&page_r=$pageR&limit_r=$limitR',
          body: body,
          requireAuth: false,
          customHeaders: customHeaders
      );

      if (response['status'] == 'success') {
        final roundFlightResponse = FlightResponse.fromJson(response);
        return {
          'success': true,
          'data': roundFlightResponse,
          // 'data' : {
          //   'onward_detail': response['data']['onward_detail'],
          //   'return_detail': response['data']['return_detail'],
          // },
          'pagination': response['pagination'],
        };
      } else {
        AppLogger.log(
            "❌ API Error! Code: ${response['code'] ?? response['status']}");
        AppLogger.log("❌ Error Message: ${response['message']}");
        AppLogger.log("❌ Error Data: ${response['data']}");
        return {
          'success': false,
          'message': response['message'],
          'code': response['code'] ?? response['status'] ?? 500,
        };
      }
    } catch(e, stacktrace){
      AppLogger.log("🔥 Exception occurred in searchRoundFlight: $e");
      AppLogger.log("🔥 Stacktrace: $stacktrace");
      return {
        'success': false,
        'message': 'Unexpected error: $e',
        'code': 500,
      };
    }
  }



}