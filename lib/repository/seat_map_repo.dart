import 'package:flightbooking/api_services/api_request/post_request.dart';
import 'package:flightbooking/api_services/configs/app_configs.dart';
import 'package:flightbooking/api_services/configs/urls.dart';
import 'package:flightbooking/models/seat_map_model/seat_map_post_model.dart';

class SeatMapRepository{
  final PostService postService = PostService();
   Future<Map<String, dynamic>>  seatMap(SeatMapPostModel payload) async{
     try{
       final response = await postService.postRequest(
           endPoint: seatMapUrl,
           body: payload.toJson(),
         customHeaders: {
             'action' : 'AirIQ',
              'api-key' : AppConfigs.apiKey
         },
         requireAuth: false
       );
       return response;
     } catch(e){
       return {
         'status' : 'error',
         'message' : e.toString()
       };
     }
   }
}