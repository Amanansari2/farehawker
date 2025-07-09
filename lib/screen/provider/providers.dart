import 'package:flutter/material.dart';

class LanguageChangeProvider with ChangeNotifier {
  Locale _currentLocale = const Locale("en");

  Locale get currentLocale => _currentLocale;

  void changeLocale(String locale) {
    _currentLocale = Locale(locale);
    notifyListeners();
  }
}





class Travelers with ChangeNotifier {
  List<Map<String, String>> _travellers = [];

  List<Map<String, String>> get travellers => _travellers;

  void addTraveler(Map<String, String> traveler) {
    _travellers.add(traveler);
    notifyListeners();
  }
  void editTraveler(int index, Map<String, String> updatedTraveler) {

      _travellers[index] = updatedTraveler;
      notifyListeners();

  }

  void deleteTraveler(int index) {
    _travellers.removeAt(index);
    notifyListeners();
  }

}

