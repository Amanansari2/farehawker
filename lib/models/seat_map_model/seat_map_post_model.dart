import 'dart:convert';

class SegmentInfo {
  final String baseOrigin;
  final String baseDestination;
  final String tripType;

  SegmentInfo({
    required this.baseOrigin,
    required this.baseDestination,
    required this.tripType,
  });

  Map<String, dynamic> toJson() => {
    "BaseOrigin": baseOrigin,
    "BaseDestination": baseDestination,
    "TripType": tripType,
  };
}

class FlightInfoSeat {
  final String flightID;
  final String flightNumber;
  final String origin;
  final String destination;
  final String departureDateTime;
  final String arrivalDateTime;

  FlightInfoSeat({
    required this.flightID,
    required this.flightNumber,
    required this.origin,
    required this.destination,
    required this.departureDateTime,
    required this.arrivalDateTime,
  });

  Map<String, dynamic> toJson() => {
    "FlightID": flightID,
    "FlightNumber": flightNumber,
    "Origin": origin,
    "Destination": destination,
    "DepartureDateTime": departureDateTime,
    "ArrivalDateTime": arrivalDateTime,
  };
}


class PaxDetail {
  final String paxRefNumber;
  final String title;
  final String paxType;
  final String firstName;
  final String lastName;

  PaxDetail({
    required this.paxRefNumber,
    required this.title,
    required this.paxType,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => {
    "PaxRefNumber": paxRefNumber,
    "Title": title,
    "PaxType": paxType,
    "FirstName": firstName,
    "LastName": lastName,
  };
}


class SeatMapPostModel {
  final SegmentInfo segmentInfo;
  final List<FlightInfoSeat> flightsInfo;
  final List<PaxDetail> apiPaxDetails;
  final String trackId;

  SeatMapPostModel({
    required this.segmentInfo,
    required this.flightsInfo,
    required this.apiPaxDetails,
    required this.trackId,
  });

  Map<String, dynamic> toJson() => {
    "SegmentInfo": segmentInfo.toJson(),
    "FlightsInfo": flightsInfo.map((e) => e.toJson()).toList(),
    "APIPaxDetails": apiPaxDetails.map((e) => e.toJson()).toList(),
    "TrackId": trackId,
  };

  String toRawJson() => jsonEncode(toJson());
}