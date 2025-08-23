import 'package:flightbooking/api_services/api_request/post_request.dart';
import 'package:flightbooking/api_services/configs/app_configs.dart';
import 'package:flightbooking/models/booking_model/booking_post_model.dart';

import '../api_services/configs/urls.dart';

class HiddenBookingRepository{
  final PostService postService = PostService();

  Future<Map<String, dynamic>> hiddenBooking(BookingRequest payload) async {
    try{
      final response = await postService.postRequest(
          endPoint: bookingUrl,
          body: payload.toJson(),
        customHeaders: {
            'action' : 'AirIQ',
             'api-key' : AppConfigs.apiKey
        },
        requireAuth: false
      );
      return response;
    } catch (e) {
      return {
        'status' : 'error',
        'message' : e.toString()
      };
    }
  }
}