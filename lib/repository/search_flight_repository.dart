import 'package:flightbooking/api_services/api_request/post_request.dart';
import 'package:flightbooking/api_services/configs/urls.dart';

class SearchFlightRepository {
  final PostService _postService = PostService();

  Future<Map<String, dynamic>> searchFlight({
    required String from,
    required String to,
    required String date,
    required String adult,
    required String child,
    required String infant
})async {
    final customHeaders = {
      'action': 'flightSearch',
      'api-key': 'ZmFyZWhhd2tlci5jb21hcGl0b2tlbg==',
    };
    final body = {
      "TripType": "O",
      "AirlineID": null,
      "DepartureStation": from,
      "ArrivalStation": to,
      "FlightDate": date,
      "FarecabinOption": null,
      "FareType": null,
      "OnlyDirectFlight": false,
      "AdultCount": adult,
      "ChildCount": child,
      "InfantCount": infant,
    };

    final response =  await _postService.postRequest(
        endPoint: flightSearch,
        body: body,
        requireAuth:  false,
        customHeaders: customHeaders
    );

    if(response['status'] == 'success'){
      return {
        'success' : true,
        'data' : response['data']
      };
    } else {
      return {
        'success': false,
        'message': response['error'] ?? 'Flight search failed',
        'data': response['response'],
      };
    }
  }
}