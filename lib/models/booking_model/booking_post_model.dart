import '../pricing_rules_model/pricing_response_model.dart';

class BookingRequest {
  final int adultCount;
  final int childCount;
  final int infantCount;
  final List<ItineraryFlightsInfo> itineraryFlightsInfo;
  final List<PaxDetailsInfo> paxDetailsInfo;
  final AddressDetails addressDetails;
  final GSTInfo gstInfo;
  final List<FFNumberInfo> ffNumberInfo;
  final String tripType;
  final bool blockPNR;
  final String baseOrigin;
  final String baseDestination;
  final String trackId;

  BookingRequest({
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    required this.itineraryFlightsInfo,
    required this.paxDetailsInfo,
    required this.addressDetails,
    required this.gstInfo,
    required this.ffNumberInfo,
    required this.tripType,
    required this.blockPNR,
    required this.baseOrigin,
    required this.baseDestination,
    required this.trackId,
  });

  Map<String, dynamic> toJson() {
    return {
      "AdultCount": adultCount,
      "ChildCount": childCount,
      "InfantCount": infantCount,
      "ItineraryFlightsInfo": itineraryFlightsInfo.map((e) => e.toJson()).toList(),
      "PaxDetailsInfo": paxDetailsInfo.map((e) => e.toJson()).toList(),
      "AddressDetails": addressDetails.toJson(),
      "GSTInfo": gstInfo.toJson(),
      "FFNumberInfo": ffNumberInfo.map((e) => e.toJson()).toList(),
      "TripType": tripType,
      "BlockPNR": blockPNR,
      "BaseOrigin": baseOrigin,
      "BaseDestination": baseDestination,
      "TrackId": trackId,
    };
  }
}

class ItineraryFlightsInfo {
  final String token;
  final List<FlightInfo> flightsInfo;
  final String paymentMode;
  final List<SeatsSSRInfo> seatsSSRInfo;
  final List<BaggSSRInfo> baggSSRInfo;
  final List<MealsSSRInfo> mealsSSRInfo;
  final List<OtherSSRInfo> otherSSRInfo;
  final List<PaymentInfo> paymentInfo;

  ItineraryFlightsInfo({
    required this.token,
    required this.flightsInfo,
    required this.paymentMode,
    required this.seatsSSRInfo,
    required this.baggSSRInfo,
    required this.mealsSSRInfo,
    required this.otherSSRInfo,
    required this.paymentInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      "Token": token,
      "FlightsInfo": flightsInfo.map((e) => e.toJson()).toList(),
      "PaymentMode": paymentMode,
      "SeatsSSRInfo": seatsSSRInfo.map((e) => e.toJson()).toList(),
      "BaggSSRInfo": baggSSRInfo.map((e) => e.toJson()).toList(),
      "MealsSSRInfo": mealsSSRInfo.map((e) => e.toJson()).toList(),
      "OtherSSRInfo": otherSSRInfo.map((e) => e.toJson()).toList(),
      "PaymentInfo": paymentInfo.map((e) => e.toJson()).toList(),
    };
  }
}

class FlightInfo {
  final String flightID;
  final String flightNumber;
  final String origin;
  final String destination;
  final String departureDateTime;
  final String arrivalDateTime;

  FlightInfo({
    required this.flightID,
    required this.flightNumber,
    required this.origin,
    required this.destination,
    required this.departureDateTime,
    required this.arrivalDateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "FlightID": flightID,
      "FlightNumber": flightNumber,
      "Origin": origin,
      "Destination": destination,
      "DepartureDateTime": departureDateTime,
      "ArrivalDateTime": arrivalDateTime,
    };
  }
}

class SeatsSSRInfo {
  final String paxRefNumber;
  final String seatID;

  SeatsSSRInfo({
    required this.paxRefNumber,
    required this.seatID,
  });

  Map<String, dynamic> toJson() {
    return {
      "PaxRefNumber": paxRefNumber,
      "SeatID": seatID,
    };
  }
}


class BaggSSRInfo {
  final String? baggageID;
  final String paxRefNumber;

  BaggSSRInfo({
    this.baggageID,
    required this.paxRefNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "BaggageID": baggageID,
      "PaxRefNumber": paxRefNumber,
    };
  }
}

extension BaggMapper on Bagg {
  BaggSSRInfo toSSRInfo({required String paxRefNumber}) {
    return BaggSSRInfo(
      baggageID: baggageID,
      paxRefNumber: paxRefNumber,
    );
  }
}


class MealsSSRInfo {
  final String? mealID;
  final String paxRefNumber;

  MealsSSRInfo({
    this.mealID,
    required this.paxRefNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "MealID": mealID,
      "PaxRefNumber": paxRefNumber,
    };
  }
}

extension MealMapper on Meal {
  MealsSSRInfo toSSRInfo({required String paxRefNumber}) {
    return MealsSSRInfo(
      mealID: mealID,
      paxRefNumber: paxRefNumber,
    );
  }
}

class OtherSSRInfo {
  final String? otherSSRID;
  final String paxRefNumber;

  OtherSSRInfo({
    this.otherSSRID,
    required this.paxRefNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "OtherSSRID": otherSSRID,
      "PaxRefNumber": paxRefNumber,
    };
  }
}

extension OtherServiceMapper on OtherService {
  OtherSSRInfo toSSRInfo({required String paxRefNumber}) {
    return OtherSSRInfo(
      otherSSRID: otherID,
      paxRefNumber: paxRefNumber,
    );
  }
}

class PaymentInfo {
  final String totalAmount;

  PaymentInfo({required this.totalAmount});

  Map<String, dynamic> toJson() {
    return {
      "TotalAmount": totalAmount,
    };
  }
}

class PaxDetailsInfo {
  final String paxRefNumber;
  final String title;
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final String paxType;
  final String passportNo;
  final String passportExpiry;
  final String passportIssuedDate;
  final String infantRef;

  PaxDetailsInfo({
    required this.paxRefNumber,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.paxType,
    required this.passportNo,
    required this.passportExpiry,
    required this.passportIssuedDate,
    required this.infantRef,
  });

  Map<String, dynamic> toJson() {
    return {
      "PaxRefNumber": paxRefNumber,
      "Title": title,
      "FirstName": firstName,
      "LastName": lastName,
      "DOB": dob,
      "Gender": gender,
      "PaxType": paxType,
      "PassportNo": passportNo,
      "PassportExpiry": passportExpiry,
      "PassportIssuedDate": passportIssuedDate,
      "InfantRef": infantRef,
    };
  }
}

class AddressDetails {
  final String countryCode;
  final String contactNumber;
  final String emailID;

  AddressDetails({
    required this.countryCode,
    required this.contactNumber,
    required this.emailID,
  });

  Map<String, dynamic> toJson() {
    return {
      "CountryCode": countryCode,
      "ContactNumber": contactNumber,
      "EmailID": emailID,
    };
  }
}

class GSTInfo {
  final String gstNumber;
  final String gstCompanyName;
  final String gstAddress;
  final String gstEmailID;
  final String gstMobileNumber;

  GSTInfo({
    required this.gstNumber,
    required this.gstCompanyName,
    required this.gstAddress,
    required this.gstEmailID,
    required this.gstMobileNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "GSTNumber": gstNumber,
      "GSTCompanyName": gstCompanyName,
      "GSTAddress": gstAddress,
      "GSTEmailID": gstEmailID,
      "GSTMobileNumber": gstMobileNumber,
    };
  }
}

class FFNumberInfo {
  final String segRefNumber;
  final String paxRefNumber;
  final String airlineCode;
  final String flyerNumber;
  final String itinref;

  FFNumberInfo({
    required this.segRefNumber,
    required this.paxRefNumber,
    required this.airlineCode,
    required this.flyerNumber,
    required this.itinref,
  });

  Map<String, dynamic> toJson() {
    return {
      "SegRefNumber": segRefNumber,
      "PaxRefNumber": paxRefNumber,
      "AirlineCode": airlineCode,
      "FlyerNumber": flyerNumber,
      "Itinref": itinref,
    };
  }
}
