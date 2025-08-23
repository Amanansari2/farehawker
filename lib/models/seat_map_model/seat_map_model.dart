import 'dart:convert';

enum SeatAvailability { open, closed, unknown }

enum SeatType { window, middle, aisle, other }

SeatAvailability _availabilityFrom(String? v) {
  switch ((v ?? '').toLowerCase()) {
    case 'open':
      return SeatAvailability.open;
    case 'closed':
      return SeatAvailability.closed;
    default:
      return SeatAvailability.unknown;
  }
}
SeatType _typeFrom(String? v) {
  switch ((v ?? '').toLowerCase()) {
    case 'window':
      return SeatType.window;
    case 'middle':
      return SeatType.middle;
    case 'aisle':
      return SeatType.aisle;
    default:
      return SeatType.other;
  }
}
class SeatItem {
  final String seatId;
  final String seatName;
  final SeatType seatType;
  final int seatAmount;
  final SeatAvailability availability;
  final int x;
  final int y;
  final String origin;
  final String destination;

  SeatItem({
    required this.seatId,
    required this.seatName,
    required this.seatType,
    required this.seatAmount,
    required this.availability,
    required this.x,
    required this.y,
    required this.origin,
    required this.destination,
  });

  factory SeatItem.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      if (v is num) return v.toInt();
      return 0;
    }

    int _amountToInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return SeatItem(
      seatId: json['SeatID']?.toString() ?? '',
      seatName: json['SeatName']?.toString() ?? '',
      seatType: _typeFrom(json['SeatType']?.toString()),
      seatAmount: _amountToInt(json['SeatAmount']),
      availability: _availabilityFrom(json['SeatAvailability']?.toString()),
      x: _toInt(json['XAxis']),
      y: _toInt(json['YAxis']),
      origin: json['Origin']?.toString() ?? '',
      destination: json['Destination']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "SeatID" : seatId,
    "SeatName": seatName,
    "SeatType": seatType.name.toUpperCase(),
    "SeatAmount": seatAmount,
    "SeatAvailability": availability.name[0].toUpperCase() +
        availability.name.substring(1),
    "XAxis": x,
    "YAxis": y,
    "Origin": origin,
    "Destination": destination,
  };
}

class SeatMapResponse {
  final String status;
  final int code;
  final Map<int, List<SeatItem>> legs;

  SeatMapResponse({
    required this.status,
    required this.code,
    required this.legs,
  });

  factory SeatMapResponse.fromJson(Map<String, dynamic> json) {
    final status = json['status']?.toString() ?? '';
    final code = (json['code'] is int)
        ? json['code'] as int
        : int.tryParse(json['code']?.toString() ?? '') ?? 0;

    final data = json['data'];
    final Map<int, List<SeatItem>> legs = {};

    if (data is Map) {
      data.forEach((k, v) {
        final legIndex = int.tryParse(k.toString());
        if (legIndex != null && v is List) {
          legs[legIndex] = v
              .whereType<Map>()
              .map((e) => SeatItem.fromJson(e.cast<String, dynamic>()))
              .toList();
        }
      });
    }

    return SeatMapResponse(status: status, code: code, legs: legs);
  }

  static SeatMapResponse fromRaw(String raw) =>
      SeatMapResponse.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
