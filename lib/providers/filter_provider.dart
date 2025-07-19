import 'package:flightbooking/models/airline_list_model.dart';
import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {

  final Map<String, String> stopOptions = {
    'nonStop': 'Non Stop',
    'oneStop': 'Up to 1 Stop',
    'all': 'All Available',
  };
  String? selectedStopOption;


  final Map<String, String> refundableOptions = {
    'refundable': 'Refundable',
    'nonrefundable': 'Non-Rufundable',
  };
  String? selectedRefundableOptions;



  final Map<String, String> departureTimeOptions = {
    'morning':'Morning',
    'afternoon':'Afternoon',
    'evening':'Evening',
    'night':'Night'
  };

  String? selectedDepartureTime;



  final Map<String, String> classOptions = {
    'Economy':'Economy',
    'PremiumEconomy':'Premium Economy',
    'Business':'Business',
    'First':'First'
  };

  String ? selectedClassOptions;

  final List<IconData> departureIcons = [
    Icons.sunny,
    Icons.wb_sunny,
    Icons.nightlight_round,
    Icons.brightness_3,
  ];


 List<Airline> airlineOptions = [];
  List<String> selectedAirlines = [];
  bool showAlliances = false;



  bool get areAllAirlinesSelected => selectedAirlines.length == airlineOptions.length;

  void filterAirlinesFromSearch(Set<String> codes, List<Airline> allAirlines){
    airlineOptions = allAirlines
        .where((airline) => codes.contains(airline.code))
        .toList()
    ..sort((a,b) => a.name.compareTo(b.name));
    notifyListeners();
  }


  void selectStopOption(String value) {
      selectedStopOption = value;
    notifyListeners();
  }

  void selectRefundableOption(String value) {
    selectedRefundableOptions = value;
    notifyListeners();
  }




  void selectDepartureTime(String value) {
    selectedDepartureTime = value;
    notifyListeners();
  }

  void selectClassOption(String value){
    selectedClassOptions = value;
    notifyListeners();
  }

  void toggleAlliance(bool value) {
    showAlliances = value;
    notifyListeners();
  }

  void toggleAirline(String code) {
    if (selectedAirlines.contains(code)) {
      selectedAirlines.remove(code);
    } else {
      selectedAirlines.add(code);
    }
    notifyListeners();
  }

  void toggleSelectAllAirlines() {
    if (selectedAirlines.length == airlineOptions.length) {
      selectedAirlines.clear();
    } else {
      selectedAirlines = airlineOptions.map((a) => a.code).toList();
    }
    notifyListeners();
  }

  bool isAirlineSelected(String code) {
    return selectedAirlines.contains(code);
  }




  void resetFilters() {
    selectedStopOption = null;
    selectedDepartureTime = null;
    selectedRefundableOptions = null;
    selectedClassOptions = null;
    selectedAirlines.clear();
    showAlliances = false;
    notifyListeners();
  }


}
