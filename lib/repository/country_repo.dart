import 'package:flightbooking/api_services/api_request/get_request.dart';
import 'package:flightbooking/api_services/configs/urls.dart';
import 'package:flightbooking/models/country_list_model.dart';

class CountryRepository{
late final GetService _getService;
CountryRepository(this._getService);

Future<List<City>> fetchCountries() async {
  final result = await _getService.getRequest(
      endPoint: countryUrl,
    requireAuth: false
  );

  if(result['status'] == true && result['data'] !=null){
    return (result['data'] as List)
        .map((e)=> City.fromJson(e as Map<String, dynamic>))
        .toList();
  }else{
    throw Exception(result["message"] ?? 'Failed to fetch Countries');
  }
}

}