import 'flight_details_model.dart';

class SearchResultArguments {
  final List<FlightDetail> flightDetail;
  final List<FlightDetail> returnFlights;
  final String fromCity;
  final String toCity;
  final DateTime travelDate;
  final DateTime? returnDate;
  final int adultCount;
  final int childCount;
  final int infantCount;
  final bool isRoundTrip;

  SearchResultArguments({
    required this.flightDetail,
    this.returnFlights = const [],
    required this.fromCity,
    required this.toCity,
    required this.travelDate,
    this.returnDate,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    this.isRoundTrip = false,
  });
}
