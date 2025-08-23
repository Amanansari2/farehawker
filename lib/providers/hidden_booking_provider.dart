import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/providers/fare_rule_provider.dart';
import 'package:flightbooking/providers/pricing_request%20_provider.dart';
import 'package:flightbooking/providers/search_flight_provider.dart';
import 'package:flightbooking/providers/seat_map_provider.dart';
import 'package:flightbooking/repository/hidden_booking_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/booking_model/booking_post_model.dart';
import '../models/flight_details_model.dart';

class HiddenBookingProvider extends ChangeNotifier{


  final HiddenBookingRepository hiddenBookingRepository = HiddenBookingRepository();



  //-----------------------  Pax Details --------------------//
    //----------------------------------------------------//

  String _norm(String value) => value.trim().toLowerCase();

  String _titleFromGender(String travellerType, String gender) {
    final t = _norm(travellerType);
    final g = _norm(gender);

    final isAdult = (t == 'adult' || t == 'adt');
    final isMinor = (t == 'child' || t == 'chd' || t == 'infant' || t == 'inf');
    final isMale = (g == 'male' || g == 'm' || g == 'boy' || g == 'b');
    final isFemale = (g == 'female' || g == 'f' || g == 'girl' || g == 'g');

    if (isAdult) {
      if (isMale) return 'MR';
      if (isFemale) return 'MS';
      return 'MR';
    }

    if (isMinor) {
      if (isMale) return 'MSTR';
      if (isFemale) return 'MISS';
      return 'MSTR';
    }

    if (isMale) return 'MR';
    if (isFemale) return 'MS';
    return 'MR';
  }
  String _paxTypeFromTraveller(String type) {
    final t = _norm(type);
    if (t == 'adult' || t == 'adt') return 'ADT';
    if (t == 'child' || t == 'chd') return 'CHD';
    if (t == 'infant' || t == 'inf') return 'INF';
    return 'ADT';
  }
  /// Format date as dd/MM/yyyy
  String _formatDob(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  BookingRequest buildBookingPayload(
      BuildContext context,
      {
        required FlightDetail flight,
        List<String>? overrideFlightIds,
    required List<SeatsSSRInfo> seats,
    required GSTInfo gstInfo,
    required List<FFNumberInfo> ffNumbers,
    List<BaggSSRInfo>? baggages,
    List<MealsSSRInfo>? meals,
    List<OtherSSRInfo>? others,
    List<PaymentInfo>? payments,
        required String token,
        required String trackId,
  }) {
    final searchProvider = context.read<SearchFlightProvider>();
    final pricingProvider = context.read<PricingProvider>();
    final fareRuleProvider = context.read<BookProceedProvider>();

    final baseStopovers = flight.stopovers;


    final flightsInfo = List<FlightInfo>.generate(baseStopovers.length, (i) {
      final s = baseStopovers[i];
      final newId = (overrideFlightIds != null && overrideFlightIds.isNotEmpty &&  overrideFlightIds.length == baseStopovers.length)
         ?overrideFlightIds[i]
          : s.flightId;

      return FlightInfo(
        flightID: newId,
        flightNumber: s.flightNumber,
        origin: s.airportOrigin,
        destination: s.airportDestination,
        departureDateTime: s.departureTime,
        arrivalDateTime: s.arrivalTime,
      );
    });

    final paxDetails = fareRuleProvider.travellers.asMap().entries.map((entry){
      final index = entry.key;
      final t = entry.value;

      return PaxDetailsInfo(
          paxRefNumber: (index + 1).toString(),
          title: _titleFromGender(t.type,t.gender),
          firstName: t.firstName,
          lastName: t.lastName,
          dob: _formatDob(t.dateOfBirth),
          gender: t.gender,
          paxType: _paxTypeFromTraveller(t.type),
          passportNo: t.passportNumber ?? "",
          passportExpiry: t.passportExpiry != null
                    ? _formatDob(t.passportExpiry!)
                      : "",
          passportIssuedDate: "",
          infantRef: ""
      );
    }).toList();

    final addressDetails = AddressDetails(
        countryCode: fareRuleProvider.countryCode,
        contactNumber: fareRuleProvider.phone,
        emailID: fareRuleProvider.email);


    final baggageList = pricingProvider.buildSelectedBaggages(
      fareRuleProvider.travellers,
    );

    AppLogger.log("🔍 Debug Travellers at booking send:");
    final travellers = context.read<BookProceedProvider>().travellers;
    travellers.asMap().forEach((i, t) {
      AppLogger.log("Traveller $i: selectedMeal count = ${t.selectedMeal?.length ?? 0}");
    });


    final mealList = pricingProvider.buildSelectedMeals(
    travellers:   fareRuleProvider.travellers, flightCount: flight.stopovers.length,
    );

    final othersList = pricingProvider.buildSelectedOthers(
     travellers:  fareRuleProvider.travellers, flightCount: flight.stopovers.length
    );



    final paymentList = payments ?? [];




    return BookingRequest(
      adultCount: searchProvider.adultCount,
      childCount: searchProvider.childCount,
      infantCount: searchProvider.infantCount,
      itineraryFlightsInfo: [
        ItineraryFlightsInfo(
          token: token,
          flightsInfo: flightsInfo,
          paymentMode: "T",
          // seatsSSRInfo:selectedSeats,
          seatsSSRInfo:seats,
          baggSSRInfo: baggageList ?? [],
          mealsSSRInfo: mealList ?? [],
          otherSSRInfo: othersList ?? [],
          paymentInfo: paymentList,
        ),
      ],
      paxDetailsInfo: paxDetails,
      addressDetails: addressDetails,
      gstInfo: GSTInfo(
          gstNumber: "",
          gstCompanyName: "",
          gstAddress: "",
          gstEmailID: "",
          gstMobileNumber: ""),
      ffNumberInfo: ffNumbers.isNotEmpty
        ? ffNumbers
      :[
        FFNumberInfo(
          segRefNumber: "",
          paxRefNumber: "",
          airlineCode: "",
          flyerNumber: "",
          itinref: ""),
      ],
      tripType: 'O',
      blockPNR: false,
      baseOrigin: flight.origin,
      baseDestination: flight.destination,
      trackId: trackId,
    );
  }


  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _response;

  bool get loading => _loading;
  String? get error => _error;
  Map<String, dynamic>? get response => _response;



  Future<void> sendBookingRequest(
      BuildContext context, {
        required FlightDetail flight,
        List<String>? overrideFlightIds,
        List<PaymentInfo>? payments,
      }) async {
    _loading = true;
    _error = null;
    _response = null;
    notifyListeners();

    try {
      final pricingProvider = context.read<PricingProvider>();
      final seatMapProvider = context.read<SeatMapProvider>();

      final fareRuleProvider = context.read<BookProceedProvider>();

      final selectedSeats = seatMapProvider.buildSelectedSeats(context);

      final selectedMeals = pricingProvider.buildSelectedMeals(
        travellers : fareRuleProvider.travellers,
        flightCount:  flight.stopovers.length,);
      final selectedBags = pricingProvider.buildSelectedBaggages(fareRuleProvider.travellers, );
      final selectedOthers = pricingProvider.buildSelectedOthers(
         travellers:  fareRuleProvider.travellers,
         flightCount: flight.stopovers.length
      );



      final double baggTotal = pricingProvider.baggageTotal;
      final double mealTotal = pricingProvider.mealTotal;
      final double otherTotal = pricingProvider.otherTotal;
      final double seatTotal = seatMapProvider.selectedSeatTotal;
      final double flightTotal = flight.grossAmount ;
      final double totalAmount = flightTotal + baggTotal + mealTotal + otherTotal + seatTotal;

      AppLogger.log(
          "Flight total -->> $flightTotal"
          "baggage total -->> $baggTotal"
              "meal total -->> $mealTotal"
              "other service total -->> $otherTotal"
              "seat total -->>> $seatTotal"
              "Total Amount -->> $totalAmount");

      AppLogger.log("🔍 Debug Travellers at booking send:");
      final travellers = context.read<BookProceedProvider>().travellers;
      travellers.asMap().forEach((i, t) {
        AppLogger.log("Traveller $i: selectedMeal count = ${t.selectedMeal?.length ?? 0}");
      });
      // Build request (everything else comes from providers inside buildBookingPayload)
      final bookingRequest = buildBookingPayload(
        context,
        flight: flight,
        overrideFlightIds: overrideFlightIds,
        seats: selectedSeats, // provider already builds seats inside payload
        gstInfo: GSTInfo(
          gstNumber: "",
          gstCompanyName: "",
          gstAddress: "",
          gstEmailID: "",
          gstMobileNumber: "",
        ),
        ffNumbers: [
          FFNumberInfo(
            segRefNumber: "",
            paxRefNumber: "",
            airlineCode: "",
            flyerNumber: "",
            itinref: "",
          )
        ],
        meals: selectedMeals,
        baggages: selectedBags,
        others: selectedOthers,
        payments: [PaymentInfo(totalAmount: totalAmount.toStringAsFixed(2))],
        token: pricingProvider.token ?? '',
        trackId: pricingProvider.latestTrackId ?? '',


      );

      // Call repository
      final result = await hiddenBookingRepository.hiddenBooking(bookingRequest);

      if ((result['status'] ?? '').toString().toLowerCase() == 'success') {
        _response = result;
        _error = null;
      } else {
        _response = result;
        _error = result['message'] ?? 'Booking failed';
      }
    } catch (e) {
      _error = e.toString();
      _response = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }


  //*****************************************//
     //***** Round Trip ***** //

  Map<String, dynamic>? _onwardResponse;
  String? _onwardError;

  Map<String, dynamic>? _returnResponse;
  String? _returnError;

  Map<String, dynamic>? get onwardResponse => _onwardResponse;
  Map<String, dynamic>? get returnResponse => _returnResponse;

  String? get onwardError => _onwardError;
  String? get returnError => _returnError;

  Future<void> sendRoundtripBookingrequest({
    required BuildContext context,
    required FlightDetail onwardFlight,
    required FlightDetail returnFlight,
    List<String>? onwardFlightIds,
    List<String>? returnFlightIds,

}) async {
    _loading = true;
    _onwardError = null;
    _returnError = null;
    _onwardResponse = null;
    _returnResponse = null;
    notifyListeners();

    try {
      final seatMapProvider = context.read<SeatMapProvider>();
      final pricingProvider = context.read<PricingProvider>();
      final fareRuleProvider = context.read<BookProceedProvider>();
      final searchProvider = context.read<SearchFlightProvider>();

      // final allSeats = seatMapProvider.buildSelectedSeats(context);
      // final onwardSeats = allSeats.where((s) => s.seatID.startsWith('O-')).toList();
      // final returnSeats = allSeats.where((s) => s.seatID.startsWith('R-')).toList();

      // final splitSeats = seatMapProvider.buildSelectedSeatsSplitByTrip(context);
      // final onwardSeats = splitSeats['Onward'] ?? [];
      // final returnSeats = splitSeats['Return'] ?? [];

      final onwardSeats = seatMapProvider.buildSelectedSeatsSplitByTrip(context)['Onward'] ?? [];
      final returnSeats = seatMapProvider.buildSelectedSeatsSplitByTrip(context)['Return'] ?? [];

      final onwardSeatPrice = seatMapProvider.onwardSeatTotal;
      final returnSeatPrice = seatMapProvider.returnSeatTotal;
      final onwardMeals = pricingProvider.buildSelectedMeals(
       travellers:  fareRuleProvider.travellers,
       flightCount:  onwardFlight.stopovers.length,
      );
      final returnMeals = pricingProvider.buildSelectedMeals(
       travellers:  fareRuleProvider.travellers,
       flightCount:  returnFlight.stopovers.length,
      );

      final onwardOthers = pricingProvider.buildSelectedOthers(
       travellers:  fareRuleProvider.travellers,
        flightCount: onwardFlight.stopovers.length
      );
      final returnOthers = pricingProvider.buildSelectedOthers(
       travellers:  fareRuleProvider.travellers,
        flightCount: returnFlight.stopovers.length
      );


      final onwardTotalAmount = onwardFlight.grossAmount +
          onwardSeatPrice +
          pricingProvider.baggageTotal +
          pricingProvider.mealTotal +
          pricingProvider.otherTotal;

      final returnTotalAmount = returnFlight.grossAmount +
          returnSeatPrice +
          pricingProvider.baggageTotal +
          pricingProvider.mealTotal +
          pricingProvider.otherTotal;

      final gstInfo = GSTInfo(
        gstNumber: "",
        gstCompanyName: "",
        gstAddress: "",
        gstEmailID: "",
        gstMobileNumber: "",
      );

      final ffNumbers = [
        FFNumberInfo(
          segRefNumber: "",
          paxRefNumber: "",
          airlineCode: "",
          flyerNumber: "",
          itinref: "",
        )
      ];

      final onwardPayload = buildBookingPayload(
        context,
        flight: onwardFlight,
        overrideFlightIds: onwardFlightIds,
        seats: onwardSeats,
        gstInfo: gstInfo,
        ffNumbers: ffNumbers,
        meals: onwardMeals,
        others: onwardOthers,
        payments: [PaymentInfo(totalAmount: onwardTotalAmount.toStringAsFixed(2))],
        token: pricingProvider.onwardLatestToken ?? '',
        trackId: pricingProvider.onwardLatestTrackId ?? '',
      );

      final onwardResult = await hiddenBookingRepository.hiddenBooking(onwardPayload);

      if ((onwardResult['status'] ?? '').toString().toLowerCase() != 'success') {
        _onwardError = onwardResult['message'] ?? 'Onward booking failed';
        _onwardResponse = onwardResult;
        AppLogger.log("❌ Onward Booking Error: $_onwardError");
      } else {
        _onwardError = null;
        _onwardResponse = onwardResult;
        AppLogger.log("✅ Onward Booking Success");
      }

      // Return

      final returnPayload = buildBookingPayload(
        context,
        flight: returnFlight,
        overrideFlightIds: returnFlightIds,
        seats: returnSeats,
        gstInfo: gstInfo,
        ffNumbers: ffNumbers,
        meals: returnMeals,
        others: returnOthers,
        payments: [PaymentInfo(totalAmount: returnTotalAmount.toStringAsFixed(2))],
        token: pricingProvider.returnLatestToken ?? '',
        trackId: pricingProvider.returnLatestTrackId ?? '',
      );

      final returnResult = await hiddenBookingRepository.hiddenBooking(returnPayload);

      if ((returnResult['status'] ?? '').toString().toLowerCase() != 'success') {
        _returnError = returnResult['message'] ?? 'Return booking failed';
        _returnResponse = returnResult;
        AppLogger.log("❌ Return Booking Error: $_returnError");
      } else {
        _returnError = null;
        _returnResponse = returnResult;
        AppLogger.log("✅ Return Booking Success");
      }

    } catch(e){
      _onwardError = e.toString();
      _returnError = e.toString();
      _onwardResponse = null;
      _returnResponse = null;
      AppLogger.log("❌ Exception during round-trip booking: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

}