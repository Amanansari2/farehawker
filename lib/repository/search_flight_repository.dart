import 'package:flightbooking/api_services/api_request/post_request.dart';
import 'package:flightbooking/api_services/configs/app_configs.dart';
import 'package:flightbooking/api_services/configs/urls.dart';

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
      "selectedTimeSlot" : null,
      "FarecabinOption": null,
      "FareType": null,
      "OnlyDirectFlight": false,
      "AdultCount": adult,
      "ChildCount": child,
      "InfantCount": infant,
      "selectedAirlines" : null,
      "refundFilter" : null
    };

    final response =  await _postService.postRequest(
        endPoint: '$flightSearch?page=$page&limit=$limit',
        body: body,
        requireAuth:  false,
        customHeaders: customHeaders
    );

    if(response['status'] == 'success'){
      return {
        'success' : true,
        'data': {
          'onward_detail': response['data']['onward_detail'],
          'return_detail': response['data']['return_detail'],
          'pagination': response['pagination'],
        }
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
}) async {
    final customHeaders = {
      'action': 'getAllSortedFares',
      'api-key': AppConfigs.apiKey,
    };
    final body = {
      "TripType": "R",
      "AirlineID": null,
      "DepartureStation": from,
      "ArrivalStation": to,
      "FlightDate": date,
      "roundDate" : returnDate,
      "selectedTimeSlot" : null,
      "FarecabinOption": null,
      "FareType": null,
      "OnlyDirectFlight": false,
      "AdultCount": adult,
      "ChildCount": child,
      "InfantCount": infant,
      "selectedAirlines" : null,
      "refundFilter" : null
    };

    final response = await _postService.postRequest(
        endPoint: '$flightSearch?page=$page&limit=$limit',
        body: body,
        requireAuth:  false,
        customHeaders: customHeaders
    );

    if(response['status'] == 'success'){
      return {
        'success' : true,
        'data' : {
          'onward_detail': response['data']['onward_detail'],
          'return_detail': response['data']['return_detail'],
          'pagination': response['pagination'],
        }
      };
    }else{
      return {
        'success': false,
        'message': response['message'],
        'code': response['code'] ?? response['status'] ?? 500,
      };
    }
  }



}