class FlightDetailOneWay {
  final String flightID;
  final String flightNumber;
  final String origin;
  final String destination;
  final String departureDateTime;
  final String arrivalDateTime;

  FlightDetailOneWay({
    required this.flightID,
    required this.flightNumber,
    required this.origin,
    required this.destination,
    required this.departureDateTime,
    required this.arrivalDateTime,
  });

  Map<String, dynamic> toJson() => {
    'FlightID': flightID,
    'FlightNumber': flightNumber,
    'Origin': origin,
    'Destination': destination,
    'DepartureDateTime': departureDateTime,
    'ArrivalDateTime': arrivalDateTime,
  };
}

class ItineraryInfo {
  final List<FlightDetailOneWay> flightDetails;
  final String baseAmount;
  final String grossAmount;

  ItineraryInfo({
    required this.flightDetails,
    required this.baseAmount,
    required this.grossAmount,
  });

  Map<String, dynamic> toJson() => {
    'FlightDetails': flightDetails.map((f) => f.toJson()).toList(),
    'BaseAmount': baseAmount,
    'GrossAmount': grossAmount,
  };
}

class SegmentInfo {
  final String baseOrigin;
  final String baseDestination;
  final String tripType;
  final String adultCount;
  final String childCount;
  final String infantCount;

  SegmentInfo({
    required this.baseOrigin,
    required this.baseDestination,
    required this.tripType,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
  });

  Map<String, dynamic> toJson() => {
    'BaseOrigin': baseOrigin,
    'BaseDestination': baseDestination,
    'TripType': tripType,
    'AdultCount': adultCount,
    'ChildCount': childCount,
    'InfantCount': infantCount,
  };
}

class PricingPayload {
  final SegmentInfo segmentInfo;
  final String trackId;
  final List<ItineraryInfo> itineraryInfo;

  PricingPayload({
    required this.segmentInfo,
    required this.trackId,
    required this.itineraryInfo,
  });

  Map<String, dynamic> toJson() => {
    'SegmentInfo': segmentInfo.toJson(),
    'Trackid': trackId,
    'ItineraryInfo': itineraryInfo.map((i) => i.toJson()).toList(),
  };
}
