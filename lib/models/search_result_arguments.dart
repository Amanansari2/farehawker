import 'flight_response_model.dart';

class SearchResultArguments {
  final FlightResponse flightResponse;
  final String fromCity;
  final String toCity;
  final DateTime travelDate;
  final int adultCount;
  final int childCount;
  final int infantCount;

  SearchResultArguments({
    required this.flightResponse,
    required this.fromCity,
    required this.toCity,
    required this.travelDate,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
  });
}
