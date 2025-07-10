import 'package:flightbooking/api_services/api_request/get_request.dart';
import 'package:flightbooking/api_services/configs/app_configs.dart';
import 'package:flightbooking/api_services/configs/urls.dart';
import 'package:flightbooking/models/airline_list_model.dart';
import 'package:flightbooking/models/airport_list_model.dart';
import 'package:flightbooking/models/country_list_model.dart';
import 'package:get_storage/get_storage.dart';

import '../api_services/app_logger.dart';

class CountryRepository{
  late final GetService _getService;
  final GetStorage _box = GetStorage();

  CountryRepository(this._getService);

  final String countryCacheKey = 'cached_countries';
  final String countryCacheTimeKey = 'cached_countries_time';

  final String airlineCacheKey = 'cached_airlines';
  final String airlineCacheTimeKey = 'cached_airlines_times';

  final String airportCacheKey = 'cached_airport';
  final String airportCacheTimeKey = 'cached_airport_time';


  Future<List<City>> fetchCountries() async {

    final  now = DateTime.now();
    final cachedAt = DateTime.tryParse(_box.read(countryCacheTimeKey) ?? '');

    if(cachedAt != null && now.difference(cachedAt).inDays < 15){
      AppLogger.log('✅ Loaded countries from local cache');
      final cachedList = _box.read<List>(countryCacheKey) ?? [];
      return cachedList.map((e) => City.fromCacheJson(Map<String, dynamic>.from(e))).toList();
    }
    AppLogger.log('🌐 Fetching countries from API');
    final result = await _getService.getRequest(
        endPoint: countryUrl2,
        requireAuth: false,
        customHeaders: {
          'action': 'countries',
          'api-key' :  AppConfigs.apiKey
        }
    );

    if((result['status'] == true || result['status'] == 'success') && result['data'] !=null){
      final cityList = (result['data'] as List)
          .map((e)=> City.fromJson(e as Map<String, dynamic>))
          .toList();

      final cacheList = cityList.map((c) => c.toCacheJson()).toList();
      _box.write(countryCacheKey, cacheList);
      _box.write(countryCacheTimeKey, now.toIso8601String());

      return cityList;

    }else{
      throw Exception(result["message"] ?? 'Failed to fetch Countries');
    }
  }




  Future<List<Airline>> fetchAirLines() async {
    final now = DateTime.now();
    final cachedAt = DateTime.tryParse(_box.read(airlineCacheTimeKey) ?? '');

    if(cachedAt != null && now.difference(cachedAt).inDays < 15){
      AppLogger.log('✅ Loaded Airlines from local cache');
      final cacheAirlineList = _box.read<List>(airlineCacheKey) ?? [];
      return cacheAirlineList.map((e) => Airline.fromCacheJson(Map<String, dynamic>.from(e))).toList();
    }
    AppLogger.log('🌐 Fetching airline from API');
    final result = await _getService.getRequest(
        endPoint: countryUrl2,
        requireAuth: false,
        customHeaders: {
          'action': 'airlines',
          'api-key' :  AppConfigs.apiKey
        }
    );

    if((result['status'] == true || result['status'] == 'success') && result['data'] != null){
      final airlineList = (result['data'] as List)
          .map((e) => Airline.fromJson(e as Map<String, dynamic>))
          .toList();

      final airlineCacheList = airlineList.map((c) => c.toCacheJson()).toList();
      _box.write(airlineCacheKey, airlineCacheList);
      _box.write(airlineCacheTimeKey, now.toIso8601String());

      return airlineList;
    }else{
      throw Exception(result["message"] ?? 'Failed to fetch Airlines');
    }

  }

  Future <List<Airport>> fetchAirport() async {
    final now = DateTime.now();
    final cachedAt = DateTime.tryParse(_box.read(airportCacheTimeKey) ?? '');

    if(cachedAt != null && now.difference(cachedAt).inDays < 15){
      AppLogger.log('✅ Loaded Airport from local cache');
      final cacheAirportList = _box.read<List>(airportCacheKey) ?? [];
      return cacheAirportList.map((e) => Airport.fromCacheJson(Map<String, dynamic>.from(e))).toList();
    }

    AppLogger.log('🌐 Fetching airport from API');
    final result = await _getService.getRequest(
        endPoint: countryUrl2,
        requireAuth: false,
      customHeaders: {
        'action': 'airports',
        'api-key' :  AppConfigs.apiKey
      }
    );

    if((result['status'] == true || result['status'] == 'success') && result['data'] != null){
      final airportList = (result['data'] as List)
          .map((e) => Airport.fromJson(e as Map<String, dynamic>))
          .toList();

      final airportCacheList = airportList.map((c) => c.toCacheJson()).toList();
      _box.write(airportCacheKey, airportCacheList);
      _box.write(airportCacheTimeKey, now.toIso8601String());

      return airportList;
    }else {
      throw Exception(result["message"] ?? "Failed to fetch Airports" );
    }
  }

}