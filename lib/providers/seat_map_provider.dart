
import 'package:collection/collection.dart';
import 'package:flightbooking/models/booking_model/booking_post_model.dart';
import 'package:flightbooking/models/flight_details_model.dart';
import 'package:flightbooking/models/seat_map_model/seat_map_post_model.dart';
import 'package:flightbooking/models/traveller_info_model.dart';
import 'package:flightbooking/repository/seat_map_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../api_services/app_logger.dart';
import '../models/seat_map_model/seat_map_model.dart';
import 'fare_rule_provider.dart';

class SeatMapProvider extends ChangeNotifier{
  final SeatMapRepository seatMapRepository = SeatMapRepository();

  /// Build APIPaxDetails from BookProceedProvider.travellers
  List<PaxDetail> _mapTravellerstoPax(List<TravellerInfo> travellers) {

    String _norm(String s) => s.trim().toLowerCase();

    String _titleFromGender(String travellerType,String gender){
      final t = _norm(travellerType);
      final g = _norm(gender);

      final isAdult = (t == 'adult' || t == 'adt');
      final isMinor = (t == 'child' || t == 'chd' || t == 'infant' || t == 'inf');
      final isMale = (g == 'male' || g == 'm' || g == 'boy' || g == 'b');
      final isFemale = (g == 'female' || g == 'f' || g == 'girl' || g == 'g');


      if (isAdult) {
        if (isMale) return 'Mr';
        if (isFemale) return 'Ms';
        return 'Mr';
      }

      if (isMinor) {
        if (isMale) return 'Mstr';
        if (isFemale) return 'Miss';
        return 'Mstr';
      }

      if (isMale) return 'Mr';
      if (isFemale) return 'Ms';
      return 'Mr';
    }

    String _paxTypeFromTraveller(String type) {
      final t= type.trim().toLowerCase();
      if(t == 'adult' || t =='adt') return 'ADT';
      if(t == 'child' || t == 'chd') return 'CHD';
      if(t == 'infant' || t == 'inf') return 'INF';
      return 'ADT';
    }

    return List<PaxDetail>.generate(travellers.length, (i){
      final t = travellers[i];
      return PaxDetail(
          paxRefNumber: (i + 1).toString(),
          title: _titleFromGender(t.type,t.gender),
          paxType: _paxTypeFromTraveller(t.type),
          firstName: t.firstName,
          lastName: t.lastName);
    });
  }

  SeatMapPostModel buildSeatMapPayload({
   required FlightDetail flight,
    required List<TravellerInfo> travellers,
    String? overRideTrackId,
    List<String>? overrideFlightIds,
    String tripType = 'O',
  }){

    final baseStopovers = flight.stopovers;


    final flightsInfo = List<FlightInfoSeat>.generate(baseStopovers.length, (i) {
      final s = baseStopovers[i];
      final newId = (overrideFlightIds != null && overrideFlightIds.isNotEmpty)
          ? (i < overrideFlightIds.length ? overrideFlightIds[i] : overrideFlightIds.last)
          : s.flightId;

      return FlightInfoSeat(
        flightID: newId,
        flightNumber: s.flightNumber,
        origin: s.airportOrigin,
        destination: s.airportDestination,
        departureDateTime: s.departureTime,
        arrivalDateTime: s.arrivalTime,
      );
    });


    final segmentInfo = SegmentInfo(
      baseOrigin: flight.origin,
      baseDestination: flight.destination,
      tripType: tripType,
    );

    final pax = _mapTravellerstoPax(travellers);

    return SeatMapPostModel(
        segmentInfo: segmentInfo,
        flightsInfo: flightsInfo,
        apiPaxDetails: pax,
        trackId: overRideTrackId?? flight.traceID);
  }


  bool _loading = false;
  String? _error;
  SeatMapResponse? _seatMap;

  bool get loading => _loading;
  String? get error => _error;
  SeatMapResponse? get seatMap => _seatMap;

  Future<void> fetchSeatMap({
    required FlightDetail flight,
    required List<TravellerInfo> travellers,
    String? pricingTrackId,
    List<String>? pricingFlightIds,
  }) async {
    _loading = true;
    _error = null;
    _seatMap = null;
    notifyListeners();

    try {
      final payload = buildSeatMapPayload(
        flight: flight,
        travellers: travellers,
        overRideTrackId: pricingTrackId,
        overrideFlightIds: pricingFlightIds,
      );

      final response = await seatMapRepository.seatMap(payload);
      final status = (response['status'] ?? '').toString().toLowerCase();
      if (status == 'success') {
        _seatMap = SeatMapResponse.fromJson(response);
        _error = null;
      } else {
        AppLogger.log('SeatMap error: ${_extractApiError(response)}');

        _error = _extractApiError(response);
        _seatMap = null;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  String _extractApiError(Map<String, dynamic> res) {
    final code = res['code']?.toString();

    final data = res['data'] as Map<String, dynamic>?;
    final rs = data?['ResponseStatus'] as Map<String, dynamic>?;
    final msgFromRS = (rs?['Error']?.toString() ?? '').trim();

    if (msgFromRS.isNotEmpty) return msgFromRS;

    final topMsg = (res['message']?.toString() ?? res['error']?.toString() ?? '').trim();
    if (topMsg.isNotEmpty) return topMsg;

    return code != null ? 'Request failed (code $code).' : 'Request failed.';
  }



// ---------- New Round-Trip State ----------
  bool _isOnwardLoading = false;
  bool _isReturnLoading = false;

  bool get isOnwardLoading => _isOnwardLoading;
  bool get isReturnLoading => _isReturnLoading;

  String? _onwardError;
  String? _returnError;

  String? get onwardError => _onwardError;
  String? get returnError => _returnError;

  SeatMapResponse? _onwardSeatMap;
  SeatMapResponse? _returnSeatMap;

  SeatMapResponse? get onwardSeatMap => _onwardSeatMap;
  SeatMapResponse? get returnSeatMap => _returnSeatMap;

  Future<void> fetchRoundTripSeatMap({
    required FlightDetail onwardFlight,
    required FlightDetail returnFlight,
    required List<TravellerInfo> travellers,
    String? onwardTrackId,
    String? returnTrackId,
    List<String>? onwardFlightIds,
    List<String>? returnFlightIds,
  }) async {
    _isOnwardLoading = true;
    _isReturnLoading = true;
    _onwardError = null;
    _returnError = null;
    _onwardSeatMap = null;
    _returnSeatMap = null;
    notifyListeners();

    try {
      final onwardPayload = buildSeatMapPayload(
        flight: onwardFlight,
        travellers: travellers,
        overRideTrackId: onwardTrackId,
        overrideFlightIds: onwardFlightIds,
        tripType: 'R',
      );

      final returnPayload = buildSeatMapPayload(
        flight: returnFlight,
        travellers: travellers,
        overRideTrackId: returnTrackId,
        overrideFlightIds: returnFlightIds,
        tripType: 'R',
      );

      final results = await Future.wait<Map<String, dynamic>>([
        seatMapRepository.seatMap(onwardPayload),
        seatMapRepository.seatMap(returnPayload),
      ]);

      final onwardResult = results[0];
      final returnResult = results[1];

      // Handle onward
      if ((onwardResult['status'] ?? '').toString().toLowerCase() != 'success') {
        _onwardError = _extractApiError(onwardResult);
        _onwardSeatMap = null;
      } else {
        _onwardSeatMap = SeatMapResponse.fromJson(onwardResult);
        _onwardError = null;
      }

      // Handle return
      if ((returnResult['status'] ?? '').toString().toLowerCase() != 'success') {
        _returnError = _extractApiError(returnResult);
        _returnSeatMap = null;
      } else {
        _returnSeatMap = SeatMapResponse.fromJson(returnResult);
        _returnError = null;
      }
    } catch (e) {
      _onwardError = e.toString();
      _returnError = e.toString();
    } finally {
      _isOnwardLoading = false;
      _isReturnLoading = false;
      notifyListeners();
    }
  }




  List<SeatItem> seatsForLeg(int legIndex) =>
      _seatMap?.legs[legIndex] ?? const [];

  int get maxX {
    final lists = _seatMap?.legs.values ?? const Iterable.empty();
    int m = 0;
    for (final l in lists) {
      for (final s in l) {
        if (s.x > m) m = s.x;
      }
    }
    return m;
  }

  int get maxY {
    final lists = _seatMap?.legs.values ?? const Iterable.empty();
    int m = 0;
    for (final l in lists) {
      for (final s in l) {
        if (s.y > m) m = s.y;
      }
    }
    return m;
  }

  void clearSelectedSeats() {
    _selectedSeatsPerLeg.clear();
    notifyListeners();
  }

  double _selectedSeatTotal = 0.0;
  double get selectedSeatTotal => _selectedSeatTotal;

  // List<SeatsSSRInfo> buildSelectedSeats(BuildContext context){
  //   final fareRuleProvider = context.read<BookProceedProvider>();
  //   final travellers = fareRuleProvider.travellers;
  //
  //   final List<SeatsSSRInfo> seatList = [];
  //   int travellerIndex = 0;
  //
  //   double seatTotal = 0.0;
  //
  //   _selectedSeatsPerLeg.forEach((legKey, seatIds){
  //     final legIndex = int.tryParse(legKey.split('-').last) ?? 0;
  //     final seatListForLeg = _seatMap?.legs[legIndex] ?? [];
  //     AppLogger.log("Selected seats for leg [$legKey]:");
  //
  //
  //     for (final seatId in seatIds) {
  //       if (travellerIndex < travellers.length) {
  //         final seatItem = seatListForLeg.firstWhereOrNull((s) => s.seatId == seatId); // 🔸
  //         if (seatItem != null) {
  //           seatTotal += seatItem.seatAmount.toDouble();
  //           AppLogger.log("- SeatID: ${seatItem.seatId}, Name: ${seatItem.seatName}, "
  //               "Amount: ₹${seatTotal.toStringAsFixed(2)}");
  //         } else {
  //           AppLogger.log("- SeatID: $seatId not found in leg $legIndex");
  //         }
  //
  //         seatList.add(
  //           SeatsSSRInfo(
  //               paxRefNumber: (travellerIndex + 1).toString(),
  //               seatID: seatId
  //           ),
  //         );
  //         travellerIndex++;
  //       }
  //     }
  //   });
  //   _selectedSeatTotal = seatTotal;
  //   return seatList;
  // }


  List<SeatsSSRInfo> buildSelectedSeats(BuildContext context) {
    final fareRuleProvider = context.read<BookProceedProvider>();
    final travellers = fareRuleProvider.travellers;

    final List<SeatsSSRInfo> seatList = [];
    int globalTravellerIndex = 0;
    double seatTotal = 0.0;

    _selectedSeatsPerLeg.forEach((legKey, seatIds) {
      final seatListForLeg = _seatMap?.legs[int.tryParse(legKey.split('-').last) ?? 0] ?? [];
      final seatIdList = seatIds.toList();

      for (int i = 0; i < seatIdList.length; i++) {
        final travellerIndex = i % travellers.length; // rotate through passengers
        final paxRefNumber = (travellerIndex + 1).toString();
        final seatItem = seatListForLeg.firstWhereOrNull((s) => s.seatId == seatIdList[i]);

        if (seatItem != null) {
          seatTotal += seatItem.seatAmount.toDouble();
          AppLogger.log("- [$legKey] SeatID: ${seatItem.seatId}, Name: ${seatItem.seatName}, Pax: $paxRefNumber");
        }

        seatList.add(
          SeatsSSRInfo(
            paxRefNumber: paxRefNumber,
             seatID: seatIdList[i],

          ),
        );
      }
    });

    _selectedSeatTotal = seatTotal;
    return seatList;
  }

  double _onwardSeatTotal = 0.0;
  double get onwardSeatTotal => _onwardSeatTotal;

  double _returnSeatTotal = 0.0;
  double get returnSeatTotal => _returnSeatTotal;

  Map<String, List<SeatsSSRInfo>> buildSelectedSeatsSplitByTrip(BuildContext context) {
    final fareRuleProvider = context.read<BookProceedProvider>();
    final travellers = fareRuleProvider.travellers;

    final Map<String, List<SeatsSSRInfo>> tripSeats = {
      'Onward': [],
      'Return': [],
    };

    double onwardTotal = 0.0;
    double returnTotal = 0.0;

    _selectedSeatsPerLeg.forEach((legKey, seatIds) {
      final parts = legKey.split('-');
      if (parts.length != 2) return;

      final tripType = parts[0]; // "Onward" or "Return"
      final legIndex = int.tryParse(parts[1]) ?? 0;
      final seatListForLeg = (tripType == 'Onward'
          ? _onwardSeatMap?.legs[legIndex]
          : _returnSeatMap?.legs[legIndex]) ?? [];

      final seatIdList = seatIds.toList();

      for (int i = 0; i < seatIdList.length; i++) {
        final travellerIndex = i % travellers.length;
        final paxRefNumber = (travellerIndex + 1).toString();
        final seatItem = seatListForLeg.firstWhereOrNull((s) => s.seatId == seatIdList[i]);

        if (seatItem != null) {
          if (tripType == 'Onward') {
            onwardTotal += seatItem.seatAmount.toDouble();
          } else {
            returnTotal += seatItem.seatAmount.toDouble();
          }

          AppLogger.log("- [$tripType-$legIndex] SeatID: ${seatItem.seatId}, Name: ${seatItem.seatName}, Pax: $paxRefNumber");
        }

        tripSeats[tripType]?.add(
          SeatsSSRInfo(
            paxRefNumber: paxRefNumber,
            seatID: seatIdList[i],
          ),
        );
      }
    });

    _onwardSeatTotal  = onwardTotal;
    _returnSeatTotal = returnTotal;

    return tripSeats;
  }




  final Map<String, Set<String>> _selectedSeatsPerLeg = {};

  Set<String> selectedSeatsForLeg(String legKey) =>
      _selectedSeatsPerLeg[legKey] ?? {};

  Set<String> get selectedSeats{
    final all = <String>{};
    _selectedSeatsPerLeg.values.forEach(all.addAll);
    return all;
  }

  void toggleSeatSelection(
      String legKey,
      SeatItem seat,
      {required int totalPassengers})
  {
    if (seat.availability != SeatAvailability.open) return;
    // final seatId = '${seat.origin}-${seat.destination}-${seat.seatName}';
    final seatId = seat.seatId;

    final selectedForLeg = _selectedSeatsPerLeg.putIfAbsent(legKey, () => {});


    if (selectedForLeg.contains(seatId)) {
      selectedForLeg.remove(seatId);
      notifyListeners();
      return;
    }

    if (selectedForLeg.length >= totalPassengers) {
      toast("You can only select $totalPassengers seats for this flight");
      return;
    }

    selectedForLeg.add(seatId);
    notifyListeners();
  }

  void toggleRoundTripSeatSelection({
    required String tripType,
    required int legIndex,
    required SeatItem seat,
    required int totalPassengers,
  }) {
    if (seat.availability != SeatAvailability.open) return;

    final legKey = '$tripType-$legIndex';
    // final seatId = '${seat.origin}-${seat.destination}-${seat.seatName}';
    final seatId = seat.seatId;

    final selectedForLeg = _selectedSeatsPerLeg.putIfAbsent(legKey, () => <String>{});

    // If seat already selected, deselect it
    if (selectedForLeg.contains(seatId)) {
      selectedForLeg.remove(seatId);
      notifyListeners();
      return;
    }

    if (selectedForLeg.length >= totalPassengers) {
      toast("You can only select $totalPassengers seats for this flight leg");
      return;
    }

    // Add the seat
    selectedForLeg.add(seatId);
    notifyListeners();
  }


}