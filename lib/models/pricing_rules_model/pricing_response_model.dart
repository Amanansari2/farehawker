class Meal {
  final String amount;
  final String code;
  final String description;
  final String mealID;
  final String destination;
  final String origin; // Note spelling fix: Orgin -> origin
  int quantity;

  Meal({
    required this.amount,
    required this.code,
    required this.description,
    required this.mealID,
    required this.destination,
    required this.origin,
    this.quantity = 0,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    amount: json['Amount'] ?? '',
    code: json['Code'] ?? '',
    description: json['Description'] ?? '',
    mealID: json['MealID'] ?? '',
    destination: json['Destination'] ?? '',
    origin: json['Orgin'] ?? '', // JSON has "Orgin"
  );

  Map<String, dynamic> toJson() => {
    'Amount': amount,
    'Code': code,
    'Description': description,
    'MealID': mealID,
    'Destination': destination,
    'Orgin': origin,
  };
}

class Bagg {
  final String amount;
  final String baggageID;
  final String baggageText;
  final String code;
  final String description;
  final String destination;
  final String origin;
  int quantity;

  Bagg({
    required this.amount,
    required this.baggageID,
    required this.baggageText,
    required this.code,
    required this.description,
    required this.destination,
    required this.origin,
    this.quantity = 0
  });

  factory Bagg.fromJson(Map<String, dynamic> json) => Bagg(
    amount: json['Amount'] ?? '',
    baggageID: json['BaggageID'] ?? '',
    baggageText: json['BaggageText'] ?? '',
    code: json['Code'] ?? '',
    description: json['Description'] ?? '',
    destination: json['Destination'] ?? '',
    origin: json['Orgin'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'Amount': amount,
    'BaggageID': baggageID,
    'BaggageText': baggageText,
    'Code': code,
    'Description': description,
    'Destination': destination,
    'Orgin': origin,
  };
}

class OtherService {
  final String amount;
  final String description;
  final String destination;
  final String origin;
  final String otherID;
  final String ssrCode;
  int quantity;

  OtherService({
    required this.amount,
    required this.description,
    required this.destination,
    required this.origin,
    required this.otherID,
    required this.ssrCode,
    this.quantity = 0,
  });

  factory OtherService.fromJson(Map<String, dynamic> json) => OtherService(
    amount: json['Amount'] ?? '',
    description: json['Description'] ?? '',
    destination: json['Destination'] ?? '',
    origin: json['Orgin'] ?? '',
    otherID: json['OtherID'] ?? '',
    ssrCode: json['SSRCode'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'Amount': amount,
    'Description': description,
    'Destination': destination,
    'Orgin': origin,
    'OtherID': otherID,
    'SSRCode': ssrCode,
  };
}

class FlightOptionsResponse {
  final String status;
  final int code;
  final String trackId;
  final String token;
  final List<String> flightIDs;
  final List<Meal> meals;
  final List<Bagg> baggs;
  final List<OtherService> otherServices;
  final String timestamp;

  FlightOptionsResponse({
    required this.status,
    required this.code,
    required this.trackId,
    required this.token,
    required this.flightIDs,
    required this.meals,
    required this.baggs,
    required this.otherServices,
    required this.timestamp,
  });

  factory FlightOptionsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return FlightOptionsResponse(
      status: json['status'] ?? '',
      code: json['code'] ?? 0,
      trackId: json['TrackId'] ?? '',
      token: json['Token'] ?? '',
      flightIDs: (data['FlightIDs'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      meals: (data['Meal'] as List<dynamic>? ?? []).map((e) => Meal.fromJson(e)).toList(),
      baggs: (data['Bagg'] as List<dynamic>? ?? []).map((e) => Bagg.fromJson(e)).toList(),
      otherServices: (data['OtherService'] as List<dynamic>? ?? []).map((e) => OtherService.fromJson(e)).toList(),
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'TrackId' : trackId,
    'Token' : token,
    'data': {
      'FlightIDs': flightIDs,
      'Meal': meals.map((e) => e.toJson()).toList(),
      'Bagg': baggs.map((e) => e.toJson()).toList(),
      'OtherService': otherServices.map((e) => e.toJson()).toList(),
    },
    'timestamp': timestamp,
  };
}
