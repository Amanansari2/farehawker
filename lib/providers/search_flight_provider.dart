import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/providers/country_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../models/country_list_model.dart';
import '../models/flight_details_model.dart';
import '../repository/search_flight_repository.dart';
import 'filter_provider.dart';

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
    final month = ["jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"][dt.month - 1];
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



  Set<String> get uniqueAirlineCodes {
    return onwardFlights.map((e) => e.airline).toSet();
  }


  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;




  Future<bool> searchFlight({
    // required BuildContext context,
    required FilterProvider filterProvider,
    required CountryProvider countryProvider,
    bool loadMore = false,
    String? stopOption,
    String? refundableOption,
    String? departureTime,
    String? selectedAirlines,
    String? classOptions,
  }) async {
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
        stopOption: stopOption,
        refundableOption: refundableOption,
        departureTime: departureTime,
        selectedAirlines: selectedAirlines,
        classOptions: classOptions
      );

      if(response['success'] == true){
        // final filterProvider = context.read<FilterProvider>();


        final FlightResponse flightData = response['data'];

        final List<FlightDetail> newOnward = flightData.onwardDetail;
        filterProvider.filterAirlinesFromSearch(
          flightData.availableAilrlines.toSet(),
          countryProvider.airlines,);

      // final  newOnward  = (response['data']['onward_detail'] as List)
      //         .map((data) => FlightDetail.fromJson(data))
      //         .toList() ?? [];
          if (loadMore) {
            onwardFlights.addAll(newOnward);
          } else {
            onwardFlights = newOnward;


          }
      final pagination = response['pagination'];
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
        isLoading = false;
        _isLoadingMore = false;
        notifyListeners();
        return false;

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


  int _returnPage = 1;
  bool _returnIsLoadingMore = false;
  bool _returnHasMore = true;

  bool get returnIsLoadingMore => _returnIsLoadingMore;
  bool get returnHasMore => _returnHasMore;

  Future<bool> searchRoundTripFlight({
    required FilterProvider filterProvider,
    required CountryProvider countryProvider,
    bool initialLoad = false,
    bool loadMoreOnward = false,
    bool loadMoreReturn = false,
    String? refundableOption,
    String? departureTime,
    String? selectedAirlines,
    String? classOptions,
    String? stopOption,
  }) async {
    if (fromCity == null) {
      validationMessage = 'Please select from City';
      notifyListeners();
      return false;
    }

    if(toCity == null){
    validationMessage = 'Please select your to City';
    notifyListeners();
    return false;
    }

    if(returnDate == null){
    validationMessage = 'Please select your return date';
    notifyListeners();
    return false;
    }

    if (initialLoad) {
      _currentPage = 1;
      _returnPage = 1;
      onwardFlights.clear();
      returnFlights.clear();
      _hasMore = true;
      _returnHasMore = true;
      isLoading = true;
      AppLogger.log("🔄 Initial round-trip search");
    }

    if (loadMoreOnward && (_isLoadingMore || !_hasMore)) {
      AppLogger.log("⚠️ Skipped onward loadMore: already loading or no more pages");
      return false;
    }
    if (loadMoreReturn && (_returnIsLoadingMore || !_returnHasMore))  {
      AppLogger.log("⚠️ Skipped return loadMore: already loading or no more pages");
      return false;
    }

    if (loadMoreOnward) {
      _isLoadingMore = true;
      _currentPage++;
      AppLogger.log("📥 Loading more onward flights: page $_currentPage");
    }

    if (loadMoreReturn) {
      _returnIsLoadingMore = true;
      _returnPage++;
      AppLogger.log("📥 Loading more return flights: page $_returnPage");
    }

    notifyListeners();

    try {
      final response = await _searchFlightRepository.searchRoundFlight(
        from: fromCity!.cityCode,
        to: toCity!.cityCode,
        date: _formatDate(selectedDate),
        returnDate: _formatDate(returnDate!),
        adult: adultCount.toString(),
        child: childCount.toString(),
        infant: infantCount.toString(),
        page: _currentPage,
        limit: 10,
        pageR: _returnPage,
        limitR: 10,
          stopOption: stopOption,
          refundableOption: refundableOption,
          departureTime: departureTime,
          selectedAirlines: selectedAirlines,
          classOptions: classOptions
      );

      if (response['success'] == true) {


        final FlightResponse  roundFlightData = response['data'] as FlightResponse;

        final List<FlightDetail> onwardData = roundFlightData.onwardDetail;
        final List<FlightDetail> returnData = roundFlightData.returnDetail;

        filterProvider.filterAirlinesFromSearch(roundFlightData.availableAilrlines.toSet(), countryProvider.airlines);

        AppLogger.log("🛫 Onward Flights Fetched: ${onwardData.length}");
        AppLogger.log("🔁 Return Flights Fetched: ${returnData.length}");
        if (initialLoad || loadMoreOnward) {
          if (loadMoreOnward) {
            onwardFlights.addAll(onwardData);
          } else {
            onwardFlights = onwardData;
          }
        }

        if (initialLoad || loadMoreReturn) {
          if (loadMoreReturn) {
            returnFlights.addAll(returnData);
          } else {
            returnFlights = returnData;
          }
        }

        final pagination = response['pagination'];
        AppLogger.log("📊 Pagination Info: $pagination");
        if (pagination is Map) {
          _hasMore = _currentPage < (int.tryParse(pagination['onward_pages'].toString()) ?? 1);
          _returnHasMore = _returnPage < (int.tryParse(pagination['return_pages'].toString()) ?? 1);
          AppLogger.log("📈 Has More Onward: $_hasMore, Has More Return: $_returnHasMore");
        }

        error = null;
      } else {
        AppLogger.log("❌ API error: ${response['message']}");
        error = response['message'] ?? 'No round-trip flights found.';
        isLoading = false;
        _isLoadingMore = false;
        _returnIsLoadingMore = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      AppLogger.log("Error during round trip flight search: $e");
      error = 'An unexpected error occurred during round-trip search.';
    }

    isLoading = false;
    _isLoadingMore = false;
    _returnIsLoadingMore = false;
    notifyListeners();

    return true;
  }

}