import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/repository/country_repo.dart';
import 'package:flutter/cupertino.dart';

import '../models/country_list_model.dart';

class CountryProvider extends ChangeNotifier{
 late  final CountryRepository _countryRepository;
    CountryProvider(this._countryRepository);

    List<City> _countries =[];
    List<City> get countries => _countries;

    bool _isLoading = false;
    bool get isLoading => _isLoading;

    String? _error;
    String? get error => _error;



    Future<void> loadCountries() async {



      _isLoading = true;
      _error = null;
      notifyListeners();

      try{
        _countries = await _countryRepository.fetchCountries();
        AppLogger.log("✅ Countries fetched: ${_countries.length}");


      } catch (e){
        _error = e.toString();
        AppLogger.log("Error ->> $_error");
      }finally{
        _isLoading = false;
        notifyListeners();
      }
    }
}