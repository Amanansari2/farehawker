import 'dart:convert';

import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/models/flight_details_model.dart';
import 'package:flightbooking/models/pricing_rules_model/one_way_pricing_request_model.dart';
import 'package:flightbooking/repository/pricing_request_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../models/booking_model/booking_post_model.dart';
import '../models/pricing_rules_model/pricing_response_model.dart';
import '../models/traveller_info_model.dart';

class PricingProvider extends ChangeNotifier{
  final PricingRepository pricingRepository = PricingRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _response;
  Map<String, dynamic>? get response => _response;

  String? _error;
  String? get error => _error;

  FlightResponse ? flightResponse;
  FlightOptionsResponse? flightOptions;

  // ===== IDs extracted from pricing responses =====
  String? _latestTrackId;
  String? get latestTrackId => _latestTrackId;

  String? _token;
  String? get token => _token;

  List<String> _latestFlightIds = [];
  List<String> get latestFlightIds => List.unmodifiable(_latestFlightIds);

  double _baggageTotal = 0.0;
  double get baggageTotal => _baggageTotal;

  double _mealTotal = 0.0;
  double get mealTotal => _mealTotal;

  double _otherTotal = 0.0;
  double get otherTotal => _otherTotal;


  List<BaggSSRInfo> buildSelectedBaggages(List<TravellerInfo> travellers) {
    final List<BaggSSRInfo> baggageList = [];
    double totalBaggagePrice = 0.0;
    int paxRefCounter = 1;

    for (var i = 0; i < travellers.length; i++) {

      final selected = travellers[i].selectedBagg;

      if (selected != null && selected.isNotEmpty) {
        for(var baggage in selected) {
          double baggagePrice = double.tryParse(baggage.amount) ?? 0.0;
          double baggageTotalAmount = baggagePrice * baggage.quantity;
          AppLogger.log(" baggage price : \$${baggagePrice.toStringAsFixed(2)},"
              "Quantity : ${baggage.quantity},"
              "Calculated Amount : \$${baggageTotalAmount.toStringAsFixed(2)}");
          for (int j = 0; j < baggage.quantity; j++) {
            final paxRefNumber =  paxRefCounter.toString();
            baggageList.add(
              baggage.toSSRInfo(paxRefNumber: paxRefNumber),
            );
            paxRefCounter++;
          }
          totalBaggagePrice += baggageTotalAmount;
        }
      }
    }

    _baggageTotal = totalBaggagePrice;
    AppLogger.log("Total Baggage Price: ${totalBaggagePrice.toStringAsFixed(2)}");
    return baggageList;
  }


  List<MealsSSRInfo> buildSelectedMeals({
    required List<TravellerInfo> travellers,
    required int flightCount,
  }) {
    final List<MealsSSRInfo> mealList = [];
    double totalMealPrice = 0.0;

    // Flatten all meals with quantity
    final List<Meal> allMeals = [];

    for (var traveller in travellers) {
      final selected = traveller.selectedMeal;

      if (selected != null && selected.isNotEmpty) {
        for (var meal in selected) {
          for (int i = 0; i < meal.quantity; i++) {
            allMeals.add(meal);
            totalMealPrice += double.tryParse(meal.amount) ?? 0.0;
          }
        }
      }
    }

    final int totalPax = travellers.length;
    final int mealsPerFlight = (allMeals.length / flightCount).ceil();

    int mealIndex = 0;

    for (int flightIndex = 0; flightIndex < flightCount; flightIndex++) {
      for (int i = 0; i < mealsPerFlight; i++) {
        if (mealIndex >= allMeals.length) break;

        final meal = allMeals[mealIndex];
        final paxRefNumber = ((i % totalPax) + 1).toString(); // 1,2,1,2,...

        mealList.add(meal.toSSRInfo(paxRefNumber: paxRefNumber));
        mealIndex++;
      }
    }

    _mealTotal = totalMealPrice;
    AppLogger.log("Manually distributed meals. Total price: \$${totalMealPrice.toStringAsFixed(2)}");
    return mealList;
  }


  List<OtherSSRInfo> buildSelectedOthers({
    required List<TravellerInfo> travellers,
    required int flightCount,
}){
    final List<OtherSSRInfo> serviceList =[];
    double totalServicePrice = 0.0;

    final List<OtherService> allServices = [];

    for(var traveller in travellers){
      final selected = traveller.selectedOther;
      if(selected != null && selected.isNotEmpty){
        for (var service in selected){
          for (int i = 0; i < service.quantity; i++){
            allServices.add(service);
            totalServicePrice += double.tryParse(service.amount) ?? 0.0;
          }
        }
      }
    }

    final int totalPax = travellers.length;
    final int servicePerFlight = (allServices.length / flightCount).ceil();
    int serviceIndex = 0;

    for(int flightIndex = 0; flightIndex < flightCount; flightIndex++){
      for(int i = 0; i < servicePerFlight; i++){
        if(serviceIndex >= allServices.length) break;

        final service = allServices[serviceIndex];
        final  paxRefNumber = ((i % totalPax) + 1).toString();

        serviceList.add(service.toSSRInfo(paxRefNumber: paxRefNumber));
        serviceIndex++;
      }
    }

    _otherTotal = totalServicePrice;
    AppLogger.log("Manually distributed meals. Total price: \$${totalServicePrice.toStringAsFixed(2)}");
    return serviceList;
  }


  //------------------------Round Trip ----------------//
  //--------------------------------------------------//

  // List<MealsSSRInfo> buildSelectedMealsForTrip({
  //   required List<TravellerInfo> travellers,
  //   required int flightCount,
  //   required String tripType, // "Onward" or "Return"
  // }) {
  //   final List<MealsSSRInfo> mealList = [];
  //   double totalMealPrice = 0.0;
  //
  //   final List<Meal> allMeals = [];
  //
  //   for (var traveller in travellers) {
  //     // choose trip-specific meals
  //     final selected = (tripType == "Onward")
  //         ? traveller.onwardSelectedMeal
  //         : traveller.returnSelectedMeal;
  //
  //     if (selected != null && selected.isNotEmpty) {
  //       for (var meal in selected) {
  //         for (int i = 0; i < meal.quantity; i++) {
  //           allMeals.add(meal);
  //           totalMealPrice += double.tryParse(meal.amount) ?? 0.0;
  //         }
  //       }
  //     }
  //   }
  //
  //   final int totalPax = travellers.length;
  //   final int mealsPerFlight = (allMeals.length / flightCount).ceil();
  //
  //   int mealIndex = 0;
  //   for (int flightIndex = 0; flightIndex < flightCount; flightIndex++) {
  //     for (int i = 0; i < mealsPerFlight; i++) {
  //       if (mealIndex >= allMeals.length) break;
  //
  //       final meal = allMeals[mealIndex];
  //       final paxRefNumber = ((i % totalPax) + 1).toString();
  //
  //       mealList.add(meal.toSSRInfo(paxRefNumber: paxRefNumber));
  //       mealIndex++;
  //     }
  //   }
  //
  //   _mealTotal = totalMealPrice;
  //   AppLogger.log("[$tripType] Meals distributed. Total: \$${totalMealPrice.toStringAsFixed(2)}");
  //   return mealList;
  // }



  PricingPayload  buildPayloadFromFlight(
      FlightDetail flight,
      int adultCount,
      int childCount,
      int infantCount
      ){
  // final flight = flightResponse.onwardDetail.first;

  final flightDetails = flight.stopovers.map((stopover) => FlightDetailOneWay(
    flightID: stopover.flightId,
    flightNumber: stopover.flightNumber,
    origin: stopover.airportOrigin,
    destination: stopover.airportDestination,
    departureDateTime: stopover.departureTime,
    arrivalDateTime: stopover.arrivalTime,
  )).toList();

  final itineraryInfo = [
    ItineraryInfo(
        flightDetails: flightDetails,
        baseAmount: flight.baseAmount.toString(),
        grossAmount: flight.grossAmount.toString()
    )
  ];
  final segmentInfo = SegmentInfo(
    baseOrigin: flight.origin,
    baseDestination: flight.destination,
    tripType: "O",
    adultCount: adultCount.toString(),
    childCount: childCount.toString(),
    infantCount: infantCount.toString(),
  );

  return PricingPayload(
    segmentInfo: segmentInfo,
    trackId: flight.traceID,
    itineraryInfo: itineraryInfo,
  );
}



  Future<void> fetchOneWayPricing(FlightDetail selectedFlight,  int adultCount,
      int childCount,
      int infantCount,)  async {
    _isLoading = true;
    _error = null;
    _response = null;
    notifyListeners();


    final payload = buildPayloadFromFlight(selectedFlight,  adultCount,
      childCount,
      infantCount,);

    final result = await pricingRepository.oneWayPricing(payload);
    final status = (result['status'] ?? '').toString().toLowerCase();
    if(status != 'success'){
      _error = result['message'] ?? "Unknown Error";
      flightOptions = null;
    } else{
      _response = result;
      flightOptions = FlightOptionsResponse.fromJson(result);

      // ===== extract from: { status, code, data: { TrackId, FlightIDs: [...] } }
      final data = (result['data'] as Map?)?.cast<String, dynamic>();
      _latestTrackId = data?['TrackId']?.toString();
      _token = data?['Token']?.toString();
      final ids = data?['FlightIDs'];
      if (ids is List) {
        _latestFlightIds = ids.map((e) => e.toString()).toList();
      }

      AppLogger.log('Latest TrackId: $_latestTrackId');
      AppLogger.log('Latest FlightIDs: ${jsonEncode(_latestFlightIds)}');

      AppLogger.log('Meals');
      for(final meal in flightOptions!.meals){
        AppLogger.log(jsonEncode(meal.toJson()));
      }
      AppLogger.log('Baggage');
      for (final bag in flightOptions!.baggs) {
        AppLogger.log(jsonEncode(bag.toJson()));
      }

      AppLogger.log('Other Services');
      for (final other in flightOptions!.otherServices) {
        AppLogger.log(jsonEncode(other.toJson()));
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  //FIELDS FOR ONWARD/RETURN
  // ------------------------------

  bool _isOnwardLoading = false;
  bool get isOnwardLoading => _isOnwardLoading;

  bool _isReturnLoading = false;
  bool get isReturnLoading => _isReturnLoading;

  Map<String, dynamic>? _onwardResponse;
  Map<String, dynamic>? get onwardResponse => _onwardResponse;

  Map<String, dynamic>? _returnResponse;
  Map<String, dynamic>? get returnResponse => _returnResponse;

  String? _onwardError;
  String? get onwardError => _onwardError;

  String? _returnError;
  String? get returnError => _returnError;

  FlightOptionsResponse? onwardOptions;
  FlightOptionsResponse? returnOptions;



  String? _onwardLatestTrackId;
  String? get onwardLatestTrackId => _onwardLatestTrackId;

  String? _returnLatestTrackId;
  String? get returnLatestTrackId => _returnLatestTrackId;

  String? _onwardLatestToken;
  String? get onwardLatestToken => _onwardLatestToken;

  String? _returnLatestToken;
  String? get returnLatestToken => _returnLatestToken;

  List<String> _onwardFlightIds = [];
  List<String> get onwardFlightIds => List.unmodifiable(_onwardFlightIds);
  List<String> _returnFlightIds = [];
  List<String> get returnFlightIds => List.unmodifiable(_returnFlightIds);



  Future<void> fetchRoundTripPricing(
      FlightDetail onwardFlight,
      FlightDetail returnFlight,
      int adultCount,
      int childCount,
      int infantCount,
      ) async {
    _isOnwardLoading = true;
    _isReturnLoading = true;
    _onwardError = null;
    _returnError = null;
    _onwardResponse = null;
    _returnResponse = null;
    notifyListeners();

    final onwardPayload = buildPayloadFromFlight(
      onwardFlight,
      adultCount,
      childCount,
      infantCount,
    );

    final returnPayload = buildPayloadFromFlight(
      returnFlight,
      adultCount,
      childCount,
      infantCount,
    );


    final results = await Future.wait<Map<String, dynamic>>([
      pricingRepository.oneWayPricing(onwardPayload),
      pricingRepository.oneWayPricing(returnPayload),
    ]);

    final onwardResult = results[0];
    final retResult = results[1];

    // Handle onward
    if (onwardResult['status'] == 'error') {
      _onwardError = onwardResult['message'] ?? "Unknown Error";
      onwardOptions = null;
    } else {
      _onwardResponse = onwardResult;
      onwardOptions = FlightOptionsResponse.fromJson(onwardResult);
      final data = (onwardResult['data'] as Map?)?.cast<String, dynamic>();
      _onwardLatestTrackId= data?['TrackId']?.toString();
      _onwardLatestToken = data?['Token']?.toString();
      final ids = data?['FlightIDs'];
      if(ids is List){
        _onwardFlightIds = ids.map((e) => e.toString()).toList();
      }

      AppLogger.log('Onward Latest TrackId: $_onwardLatestTrackId');
      AppLogger.log('Onward Latest Token: $_onwardLatestToken');
      AppLogger.log('Onward Latest FlightIDs: ${jsonEncode(_onwardFlightIds)}');


      AppLogger.log('Onward Meals');
      for (final meal in onwardOptions!.meals) {
        AppLogger.log(jsonEncode(meal.toJson()));
      }
      AppLogger.log('Onward Baggage');
      for (final bag in onwardOptions!.baggs) {
        AppLogger.log(jsonEncode(bag.toJson()));
      }
      AppLogger.log('Onward Other Services');
      for (final other in onwardOptions!.otherServices) {
        AppLogger.log(jsonEncode(other.toJson()));
      }
    }

    // Handle return
    if (retResult['status'] == 'error') {
      _returnError = retResult['message'] ?? "Unknown Error";
      returnOptions = null;
    } else {
      _returnResponse = retResult;
      returnOptions = FlightOptionsResponse.fromJson(retResult);

      final data = (retResult['data'] as Map?)?.cast<String, dynamic>();
      _returnLatestTrackId= data?['TrackId']?.toString();
      _returnLatestToken = data?['Token']?.toString();
      final ids = data?['FlightIDs'];
      if(ids is List){
        _returnFlightIds = ids.map((e) => e.toString()).toList();
      }

      AppLogger.log('Return Latest TrackId: $_returnLatestTrackId');
      AppLogger.log('Return Latest Token: $_returnLatestToken');
      AppLogger.log('Return Latest FlightIDs: ${jsonEncode(_returnFlightIds)}');


      AppLogger.log('Return Meals');
      for (final meal in returnOptions!.meals) {
        AppLogger.log(jsonEncode(meal.toJson()));
      }
      AppLogger.log('Return Baggage');
      for (final bag in returnOptions!.baggs) {
        AppLogger.log(jsonEncode(bag.toJson()));
      }
      AppLogger.log('Return Other Services');
      for (final other in returnOptions!.otherServices) {
        AppLogger.log(jsonEncode(other.toJson()));
      }
    }

    _isOnwardLoading = false;
    _isReturnLoading = false;
    notifyListeners();
  }

  void clearSelectedServices(List<TravellerInfo> travellers) {
    for (var traveller in travellers) {

      traveller.selectedMeal = [];
      traveller.selectedBagg = [];
      traveller.selectedOther = [];
    }
    notifyListeners();
  }




}