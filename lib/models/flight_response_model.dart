
class FlightResponse {
  final String status;
  final FlightData data;

  FlightResponse({required this.status, required this.data});

  factory FlightResponse.fromJson(Map<String, dynamic> json) => FlightResponse(
    status: json['status'],
    data: FlightData.fromJson(json['data']),
  );
}

class FlightData {
  final String trackId;
  final List<ItineraryFlight> itineraryFlightList;
  final Status status;

  FlightData({
    required this.trackId,
    required this.itineraryFlightList,
    required this.status,
  });

  factory FlightData.fromJson(Map<String, dynamic> json) => FlightData(
    trackId: json['Trackid'],
    itineraryFlightList: (json['ItineraryFlightList'] as List)
        .map((e) => ItineraryFlight.fromJson(e))
        .toList(),
    status: Status.fromJson(json['Status']),
  );
}

class ItineraryFlight {
  final List<Item> items;

  ItineraryFlight({required this.items});

  factory ItineraryFlight.fromJson(Map<String, dynamic> json) => ItineraryFlight(
    items: (json['Items'] as List).map((e) => Item.fromJson(e)).toList(),
  );
}

class Item {
  final List<FlightDetail> flightDetails;
  final List<Fare> fares;

  Item({required this.flightDetails, required this.fares});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    flightDetails: (json['FlightDetails'] as List)
        .map((e) => FlightDetail.fromJson(e))
        .toList(),
    fares: (json['Fares'] as List).map((e) => Fare.fromJson(e)).toList(),
  );
}

class FlightDetail {
  final String flightID;
  final String airlineDescription;
  final String flightNumber;
  final String origin;
  final String destination;
  final String departureTerminal;
  final String arrivalTerminal;
  final String departureDateTime;
  final String arrivalDateTime;
  final String flightClass;
  final String journeyTime;
  final String referenceToken;
  final String segRef;
  final String itinRef;
  final String connectionFlag;
  final String fareId;
  final String cabin;
  final String fareBasisCode;
  final String stops;
  final String via;
  final String airlineCategory;
  final String cnx;
  final String platingCarrier;
  final String operatingCarrier;
  final String segmentDetails;
  final String flyingTime;
  final bool offlineIndicator;
  final String multiClass;
  final bool allowFQT;
  final String availSeat;
  final String promoCode;
  final String promoCodeDesc;
  final String fareTypeDescription;
  final String fareDescription;
  final String fareRuleInfo;
  final String refundable;
  final String baggage;

  FlightDetail({
    required this.flightID,
    required this.airlineDescription,
    required this.flightNumber,
    required this.origin,
    required this.destination,
    required this.departureTerminal,
    required this.arrivalTerminal,
    required this.departureDateTime,
    required this.arrivalDateTime,
    required this.flightClass,
    required this.journeyTime,
    required this.referenceToken,
    required this.segRef,
    required this.itinRef,
    required this.connectionFlag,
    required this.fareId,
    required this.cabin,
    required this.fareBasisCode,
    required this.stops,
    required this.via,
    required this.airlineCategory,
    required this.cnx,
    required this.platingCarrier,
    required this.operatingCarrier,
    required this.segmentDetails,
    required this.flyingTime,
    required this.offlineIndicator,
    required this.multiClass,
    required this.allowFQT,
    required this.availSeat,
    required this.promoCode,
    required this.promoCodeDesc,
    required this.fareTypeDescription,
    required this.fareDescription,
    required this.fareRuleInfo,
    required this.refundable,
    required this.baggage,
  });

  factory FlightDetail.fromJson(Map<String, dynamic> json) => FlightDetail(
    flightID: json['FlightID'] ?? '',
    airlineDescription: json['AirlineDescription'] ?? '',
    flightNumber: json['FlightNumber'] ?? '',
    origin: json['Origin'] ?? '',
    destination: json['Destination'] ?? '',
    departureTerminal: json['DepartureTerminal'] ?? '',
    arrivalTerminal: json['ArrivalTerminal'] ?? '',
    departureDateTime: json['DepartureDateTime'] ?? '',
    arrivalDateTime: json['ArrivalDateTime'] ?? '',
    flightClass: json['Class'] ?? '',
    journeyTime: json['JourneyTime'] ?? '',
    referenceToken: json['ReferenceToken'] ?? '',
    segRef: json['SegRef'] ?? '',
    itinRef: json['ItinRef'] ?? '',
    connectionFlag: json['ConnectionFlag'] ?? '',
    fareId: json['FareId'] ?? '',
    cabin: json['Cabin'] ?? '',
    fareBasisCode: json['FareBasisCode'] ?? '',
    stops: json['Stops'] ?? '',
    via: json['Via'] ?? '',
    airlineCategory: json['AirlineCategory'] ?? '',
    cnx: json['CNX'] ?? '',
    platingCarrier: json['PlatingCarrier'] ?? '',
    operatingCarrier: json['OperatingCarrier'] ?? '',
    segmentDetails: json['SegmentDetails'] ?? '',
    flyingTime: json['FlyingTime'] ?? '',
    offlineIndicator: json['OfflineIndicator'] ?? false,
    multiClass: json['MultiClass']?.toString() ?? '',
    allowFQT: json['AllowFQT'] ?? false,
    availSeat: json['AvailSeat'] ?? '',
    promoCode: json['PromoCode'] ?? '',
    promoCodeDesc: json['PromoCodeDesc'] ?? '',
    fareTypeDescription: json['FareTypeDescription'] ?? '',
    fareDescription: json['FareDescription'] ?? '',
    fareRuleInfo: json['FareRuleInfo'] ?? '',
    refundable: json['Refundable'] ?? '',
    baggage: json['Baggage'] ?? '',
  );
}

class Fare {
  final String currency;
  final String fareType;
  final List<FareDescription> fareDescription;
  final String flightId;

  Fare({
    required this.currency,
    required this.fareType,
    required this.fareDescription,
    required this.flightId,
  });

  factory Fare.fromJson(Map<String, dynamic> json) => Fare(
    currency: json['Currency'],
    fareType: json['FareType'],
    fareDescription: (json['Faredescription'] as List)
        .map((e) => FareDescription.fromJson(e))
        .toList(),
    flightId: json['FlightId'],
  );
}

class FareDescription {
  final String paxType;
  final String baseAmount;
  final String totalTaxAmount;
  final String grossAmount;
  final String netAmount;
  final String commission;
  final String incentive;
  final String serviceCharge;
  final String tds;
  final String discount;
  final String plbAmount;
  final String sf;
  final String sfGst;
  final List<Tax> taxes;

  FareDescription({
    required this.paxType,
    required this.baseAmount,
    required this.totalTaxAmount,
    required this.grossAmount,
    required this.netAmount,
    required this.commission,
    required this.incentive,
    required this.serviceCharge,
    required this.tds,
    required this.discount,
    required this.plbAmount,
    required this.sf,
    required this.sfGst,
    required this.taxes,
  });

  factory FareDescription.fromJson(Map<String, dynamic> json) => FareDescription(
    paxType: json['Paxtype'],
    baseAmount: json['BaseAmount'].toString(),
    totalTaxAmount: json['TotalTaxAmount'].toString(),
    grossAmount: json['GrossAmount'].toString(),
    netAmount: json['NetAmount'].toString(),
    commission: json['Commission'],
    incentive: json['Incentive'],
    serviceCharge: json['Servicecharge'],
    tds: json['TDS'],
    discount: json['Discount'],
    plbAmount: json['PLBAmount'],
    sf: json['SF'],
    sfGst: json['SFGST'],
    taxes: (json['Taxes'] as List).map((e) => Tax.fromJson(e)).toList(),
  );
}

class Tax {
  final String amount;
  final String code;

  Tax({required this.amount, required this.code});

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
    amount: json['Amount'].toString(),
    code: json['Code'],
  );
}

class Status {
  final String error;
  final String resultCode;
  final String sequenceID;

  Status({required this.error, required this.resultCode, required this.sequenceID});

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    error: json['Error'],
    resultCode: json['ResultCode'],
    sequenceID: json['SequenceID'],
  );
}
