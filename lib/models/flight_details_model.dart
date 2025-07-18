class FlightResponse {
  final String status;
  final int code;
  final String message;
  final List<FlightDetail> onwardDetail;
  final List<FlightDetail> returnDetail;
  final List<String> availableAilrlines;
  final Pagination pagination;
  final String timestamp;

  FlightResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.onwardDetail,
    required this.returnDetail,
    required this.availableAilrlines,
    required this.pagination,
    required this.timestamp,
  });

  factory FlightResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};


    final onwardRaw = data['onward_detail'];
    final onwardList = (onwardRaw is List)
        ? onwardRaw.map((e) => FlightDetail.fromJson(e)).toList()
        : <FlightDetail>[];


    final returnRaw = data['return_detail'];
    final returnList = (returnRaw is List)
        ? returnRaw.map((e) => FlightDetail.fromJson(e)).toList()
        : <FlightDetail>[];


    final airlinesRaw = data['available_airlines'];
    final airlinesList = (airlinesRaw is List)
        ? airlinesRaw.map((e) => e.toString()).toList()
        : <String>[];

    final paginationRaw = json['pagination'];
    final paginationObj = (paginationRaw is Map<String, dynamic>)
        ? Pagination.fromJson(paginationRaw)
        : Pagination(page: 0, limit: 0, pager: 0, limitr: 0, onwardTotal: 0, onwardPages: 0, returnTotal: 0, returnPages: 0);

    return FlightResponse(
      status: json['status'] ?? '',
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      onwardDetail: onwardList,
      // (json['data']['onward_detail'] as List<dynamic>)
      //     .map((e) => FlightDetail.fromJson(e))
      //     .toList(),
       returnDetail: returnList,
       // (json['data']['return_detail'] as List<dynamic>)
      //     .map((e) => FlightDetail.fromJson(e))
      //     .toList(),
      availableAilrlines: airlinesList,
      // (json['data']['available_airlines'] as List<dynamic>)
      // .map((e)=> e.toString())
      // .toList(),
      pagination: paginationObj,
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': {
      'onward_detail': onwardDetail.map((e) => e.toJson()).toList(),
      'return_detail': returnDetail.map((e) => e.toJson()).toList(),
      'available_airline': availableAilrlines
    },
    'pagination': pagination.toJson(),
    'timestamp': timestamp,
  };
}

class FlightDetail {
  final String source;
  final double fare;
  final double adultFare;
  final double childFare;
  final double infantFare;
  final String totalFare;
  final double offeredFare;
  final double baseFare;
  final double tax;
  final String flightID;
  final String flightNumber;
  final String airline;
  final String origin;
  final String destination;
  final String departure;
  final String departureTime;
  final String arrival;
  final String arrivalTime;
  final String departureTerminal;
  final String arrivalTerminal;
  final int journeyTime;
  final String journeyPoints;
  final int stops;
  final String adultBaggage;
  final String childBaggage;
  final String infantBaggage;
  final String totalBaggage;
  final String cabinClass;
  final bool isRefundable;
  final bool isLcc;
  final bool gstAllowed;
  final bool couponApplicable;
  final String resultIndex;
  final String traceID;
  final int availSeat;

  FlightDetail({
    required this.source,
    required this.fare,
    required this.adultFare,
    required this.childFare,
    required this.infantFare,
    required this.totalFare,
    required this.offeredFare,
    required this.baseFare,
    required this.tax,
    required this.flightID,
    required this.flightNumber,
    required this.airline,
    required this.origin,
    required this.destination,
    required this.departure,
    required this.departureTime,
    required this.arrival,
    required this.arrivalTime,
    required this.departureTerminal,
    required this.arrivalTerminal,
    required this.journeyTime,
    required this.journeyPoints,
    required this.stops,
    required this.adultBaggage,
    required this.childBaggage,
    required this.infantBaggage,
    required this.totalBaggage,
    required this.cabinClass,
    required this.isRefundable,
    required this.isLcc,
    required this.gstAllowed,
    required this.couponApplicable,
    required this.resultIndex,
    required this.traceID,
    required this.availSeat,
  });

  factory FlightDetail.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }

    return FlightDetail(
      source: json['source'] ?? '',
      fare: parseDouble(json['fare']),
      adultFare: parseDouble(json['adult_fare']),
      childFare: parseDouble(json['child_fare']),
      infantFare: parseDouble(json['infant_fare']),
      totalFare: json['total_fare'] ?? '',
      offeredFare: parseDouble(json['offered_fare']),
      baseFare: parseDouble(json['base_fare']),
      tax: parseDouble(json['tax']),
      flightID: json['FlightID'] ?? '',
      flightNumber: json['flight_number'] ?? '',
      airline: json['airline'] ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      departure: json['departure'] ?? '',
      departureTime: json['departure_time'] ?? '',
      arrival: json['arrival'] ?? '',
      arrivalTime: json['arrival_time'] ?? '',
      departureTerminal: json['departure_terminal'] ?? '',
      arrivalTerminal: json['arrival_terminal'] ?? '',
      journeyTime: parseInt(json['JourneyTime']),
      journeyPoints: json['JourneyPoints'] ?? '',
      stops: parseInt(json['Stops']),
      adultBaggage: json['adult_baggage'] ?? '',
      childBaggage: json['child_baggage'] ?? '',
      infantBaggage: json['infant_baggage'] ?? '',
      totalBaggage: json['total_baggage'] ?? '',
      cabinClass: json['cabin_class'] ?? '',
      isRefundable:  json['is_refundable'].toString().toLowerCase() == 'true',
      isLcc: json['is_lcc'].toString().toLowerCase() == 'true',
      gstAllowed: json['gst_allowed'].toString().toLowerCase() == 'true',
      couponApplicable: json['coupon_applicable'].toString().toLowerCase() == 'true',
      resultIndex: json['result_index'] ?? '',
      traceID: json['trace_id'] ?? '',
      availSeat: parseInt(json['AvailSeat']),
    );
  }

  Map<String, dynamic> toJson() => {
    'source': source,
    'fare': fare,
    'adult_fare': adultFare,
    'child_fare': childFare,
    'infant_fare': infantFare,
    'total_fare': totalFare,
    'offered_fare': offeredFare,
    'base_fare': baseFare,
    'tax': tax,
    'FlightID': flightID,
    'flight_number': flightNumber,
    'airline': airline,
    'origin': origin,
    'destination': destination,
    'departure': departure,
    'departure_time': departureTime,
    'arrival': arrival,
    'arrival_time': arrivalTime,
    'departure_terminal': departureTerminal,
    'arrival_terminal': arrivalTerminal,
    'JourneyTime': journeyTime,
    'JourneyPoints': journeyPoints,
    'Stops': stops,
    'adult_baggage': adultBaggage,
    'child_baggage': childBaggage,
    'infant_baggage': infantBaggage,
    'total_baggage': totalBaggage,
    'cabin_class': cabinClass,
    'is_refundable': isRefundable,
    'is_lcc': isLcc,
    'gst_allowed': gstAllowed,
    'coupon_applicable': couponApplicable,
    'result_index': resultIndex,
    'trace_id': traceID,
    'AvailSeat': availSeat,
  };
}

class Pagination {
  final int page;
  final int limit;
  final int pager;
  final int limitr;
  final int onwardTotal;
  final int onwardPages;
  final int returnTotal;
  final int returnPages;

  Pagination({
    required this.page,
    required this.limit,
    required this.pager,
    required this.limitr,
    required this.onwardTotal,
    required this.onwardPages,
    required this.returnTotal,
    required this.returnPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      pager: json['page_r'] ?? 0,
      limitr: json['limit_r'] ?? 0,
      onwardTotal: json['onward_total'] ?? 0,
      onwardPages: json['onward_pages'] ?? 0,
      returnTotal: json['return_total'] ?? 0,
      returnPages: json['return_pages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'page_r': pager,
    'limit_r': limitr,
    'onward_total': onwardTotal,
    'onward_pages': onwardPages,
    'return_total': returnTotal,
    'return_pages': returnPages,
  };
}
