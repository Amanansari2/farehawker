import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flutter/cupertino.dart';

import '../models/country_list_model.dart';
import '../models/flight_details_model.dart';
import '../repository/search_flight_repository.dart';

class SearchFlightProvider extends ChangeNotifier{
  final SearchFlightRepository _searchFlightRepository = SearchFlightRepository();

  int selectedTripIndex = 0;

  City? fromCity;
  City? toCity;
  DateTime selectedDate = DateTime.now();
  DateTime? returnDate;
  String get returnDateTitle => returnDate != null ? _formatDate(returnDate!) : 'Select Return Date';
  int adultCount = 1, childCount = 0, infantCount = 0;
  String validationMessage = '';
  bool isLoading = false;
  List<FlightDetail> onwardFlights = [];
  List<FlightDetail> returnFlights = [];
  String? error;


  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;


  String get departureDateTitle => _formatDate(selectedDate);
  String get routeInfo => _buildRouteInfo();


  bool get isRoundTrip => selectedTripIndex == 1;


  void setTripIndex(int index) {
    selectedTripIndex = index;
    AppLogger.log("Selected Index -->> $selectedTripIndex");
    notifyListeners();
  }

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

  bool setReturnDate(DateTime dt) {
    if (dt.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      validationMessage = 'You cannot select a past date';
      notifyListeners();
      return false;
    }else {
      returnDate = dt;
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

  String _formatDate(DateTime dt)  {
    final day = dt.day.toString().padLeft(2, '0');
    final month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][dt.month - 1];
    final year = dt.year.toString().substring(2);
    return '$day-$month-$year';
  }


  String _buildRouteInfo() {
    final f = fromCity?.city ?? "";
    final t = toCity?.city ?? "";
    final wd = ["", "Mon","Tue","Wed","Thu","Fri","Sat","Sun"][selectedDate.weekday];
    final md = ["", "Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"][selectedDate.month];
    return '$f to $t, $wd ${selectedDate.day.toString().padLeft(2,'0')} $md ${selectedDate.year}';
  }

  Future<bool> searchFlight({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !_hasMore) {
        return false;
      }
      _isLoadingMore = true;
      _currentPage++;
    } else {
      if (fromCity == null) {
        validationMessage = 'Please select from City';
        notifyListeners();
        return false;
      }
      if (toCity == null) {
        validationMessage = 'Please select to City';
        notifyListeners();
        return false;
      }
      isLoading = true;
      _currentPage = 1;
      _hasMore = true;
      onwardFlights.clear();
      returnFlights.clear();
    }
    notifyListeners();

    try{

      final response = await _searchFlightRepository.searchFlight(
          from: fromCity!.cityCode,
          to: toCity!.cityCode,
          date: _formatDate(selectedDate),
          adult: adultCount.toString(),
          child: childCount.toString(),
          infant: infantCount.toString(),
         page: _currentPage,
         limit: 10,
      );

      if(response['success'] == true){

      final  newOnward  = (response['data']['onward_detail'] as List)
              .map((data) => FlightDetail.fromJson(data))
              .toList() ?? [];
          if (loadMore) {
            onwardFlights.addAll(newOnward);
          } else {
            onwardFlights = newOnward;
          }
      final pagination = response['data']?['pagination'];
      if (pagination is Map)  {
        final totalPages = selectedTripIndex == 0
            ? int.tryParse(pagination['onward_pages'].toString()) ?? 1
            : int.tryParse(pagination['return_pages'].toString()) ?? 1;
        _hasMore = _currentPage < totalPages;
      } else {
        _hasMore = newOnward.length == 10;
      }
        error = null;
      }else{

        if (!loadMore) {
          onwardFlights.clear();
        }
        error = response['message'] ?? 'No flights found for the selected route and date.';

      }
    }catch(e){
      isLoading = false;
      _isLoadingMore = false;
      AppLogger.log("Error during flight search: $e");
      error = 'An unexpected error occurred. Please try again.';
      if (!loadMore) {
        onwardFlights.clear();
      }
    }
    isLoading = false;
    _isLoadingMore = false;
    notifyListeners();

    return true;
  }



}