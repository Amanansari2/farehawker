import 'package:flutter/cupertino.dart';

import '../models/country_list_model.dart';
import '../models/flight_response_model.dart';
import '../repository/search_flight_repository.dart';

class SearchFlightProvider extends ChangeNotifier{
  final SearchFlightRepository _searchFlightRepository = SearchFlightRepository();

  City? fromCity;
  City? toCity;
  DateTime selectedDate = DateTime.now();
  int adultCount = 1, childCount = 0, infantCount = 0;
  String validationMessage = '';
  bool isLoading = false;
  FlightResponse? result;
  String? error;

  String get departureDateTitle => _formatDate(selectedDate);
  String get routeInfo => _buildRouteInfo();


  void setFromCity(City city) {
    fromCity = city;
    notifyListeners();
  }

  void setToCity(City city){
    toCity = city;
    notifyListeners();
  }

  bool setDate(DateTime dt) {
    if (dt.isBefore(DateTime.now().subtract(const Duration(days:1)))) {
      validationMessage = 'You cannot select a past date';
      notifyListeners();
      return false;
    } else {
      selectedDate = dt;
      validationMessage = '';
      notifyListeners();
      return true;
    }
  }

  void changePassengerCount({int adults=0, int children=0, int infants=0}) {
    int newAdults = adultCount + adults;
    int newChildren = childCount + children;
    int newInfants = infantCount + infants;
    int total = newAdults + newChildren + newInfants;

    if (total > 9) {
      validationMessage = 'Total cannot exceed 9. Go to group booking.';
      notifyListeners();
      return;
    }

    if (newInfants > newAdults) {
      validationMessage = 'Each adult can only bring 1 infant';
      notifyListeners();
      return;
    }

    adultCount = newAdults.clamp(1, 9);
    childCount = newChildren.clamp(0, 9);
    infantCount = newInfants.clamp(0, 9);
    validationMessage = '';
    notifyListeners();
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}';


  String _buildRouteInfo() {
    final f = fromCity?.city ?? "";
    final t = toCity?.city ?? "";
    final wd = ["", "Mon","Tue","Wed","Thu","Fri","Sat","Sun"][selectedDate.weekday];
    final md = ["", "Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"][selectedDate.month];
    return '$f to $t, $wd ${selectedDate.day.toString().padLeft(2,'0')} $md ${selectedDate.year}';
  }

  Future<bool> searchFlight() async {
    if(fromCity == null ){
      validationMessage = 'Please select from City';
      notifyListeners();
      return false;
    }
    if(toCity == null ){
      validationMessage = 'Please select to City';
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try{
      final response = await _searchFlightRepository.searchFlight(
          from: fromCity!.cityCode,
          to: toCity!.cityCode,
          date: _formatDate(selectedDate),
          adult: adultCount.toString(),
          child: childCount.toString(),
          infant: infantCount.toString()
      );

      isLoading = false;
      if(response['success'] == true){
        result = FlightResponse.fromJson({
          'status' : 'success',
          'data' : response['data']
        });
        error = null;
      }else{
        result = null;
        error = response['message'] ?? 'Something went wrong please try again';
      }
    }catch(e){
      isLoading = false;
      error = e.toString();
    }
    notifyListeners();
    return true;
  }
}