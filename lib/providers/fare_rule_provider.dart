import 'package:flutter/foundation.dart';
import '../models/flight_details_model.dart';
import '../repository/fare_rule_repo.dart';

class BookProceedProvider extends ChangeNotifier {

  final FareRulesRepository repository;
  BookProceedProvider({required this.repository});

  bool _isLoading = false;
  String? _fareRulesContent;
  String? _error;

  bool get isLoading => _isLoading;
  String? get fareRulesContent => _fareRulesContent;
  String? get error => _error;

  Future<void> loadFareRulesForFlight(FlightDetail flight) async {
    _isLoading = true;
    _error = null;
    _fareRulesContent = null;
    notifyListeners();

    try {
      if (flight.source == 'TBO') {
        _fareRulesContent = await repository.fetchTboFareRulesHtml(
          source: flight.source,
          traceId: flight.traceID,
          flightId: flight.flightID,
          resultIndex: flight.resultIndex,
        );
      } else if (flight.source == 'AirIQ') {
        _fareRulesContent = await repository.fetchAirIqFareRulesText(
          source: flight.source,
          traceId: flight.traceID,
          flightId: flight.flightID,
          resultIndex: flight.resultIndex,
        );
      } else {
        _error = 'Unknown source: ${flight.source}';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  List<Map<String, String>> getBaggageRows(
      FlightDetail flight, {
        required int adultCount,
        required int childCount,
        required int infantCount,
      }) {
    List<Map<String, String>> rows = [];

    String parseChecked(String baggage) {
      if (baggage.contains('+')) return baggage.split('+')[0].trim();
      return baggage;
    }

    String parseCabin(String baggage) {
      if (baggage.contains('+')) return baggage.split('+')[1].trim();
      return baggage;
    }

    if (adultCount > 0) {
      rows.add({
        'type': 'Adult',
        'checked': parseChecked(flight.adultBaggage ?? ''),
        'cabin': parseCabin(flight.adultBaggage ?? ''),
      });
    }

    if (childCount > 0) {
      rows.add({
        'type': 'Child',
        'checked': parseChecked(flight.childBaggage ?? ''),
        'cabin': parseCabin(flight.childBaggage ?? ''),
      });
    }

    if (infantCount > 0) {
      rows.add({
        'type': 'Infant',
        'checked': parseChecked(flight.infantBaggage ?? ''),
        'cabin': parseCabin(flight.infantBaggage ?? ''),
      });
    }

    return rows;
  }


  String formatFareRulesHtml(String raw) {
    String withBreaks = raw.replaceAll('\n', '<br>');
    withBreaks = withBreaks.replaceAllMapped(RegExp(r'-{4,}'),
            (match) => '<br><br>');
    final bulletLines = withBreaks
        .split('*')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (bulletLines.isEmpty) return withBreaks;

    final buffer = StringBuffer('<ul>');
    for (var line in bulletLines) {
      buffer.write('<li>$line</li>');
    }
    buffer.write('</ul>');
    return buffer.toString();
  }


}
