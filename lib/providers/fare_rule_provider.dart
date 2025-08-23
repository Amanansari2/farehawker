import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/providers/search_flight_provider.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import '../models/flight_details_model.dart';
import '../models/traveller_info_model.dart';
import '../repository/fare_rule_repo.dart';
import '../widgets/custom_dialog.dart';
import 'package:intl/intl.dart';


class BookProceedProvider extends ChangeNotifier {

  final FareRulesRepository repository;
  BookProceedProvider({required this.repository});

  bool _isLoading = false;
  String? _fareRulesContent;
  String? _error;

  bool get isLoading => _isLoading;
  String? get fareRulesContent => _fareRulesContent;
  String? get error => _error;

  String? _onwardFareRulesError;
  String? _returnFareRulesError;

  String? get onwardFareRulesError => _onwardFareRulesError;
  String? get returnFareRulesError => _returnFareRulesError;

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
          traceId: flight.traceID,
          flightIds: [flight.flightID],
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

  // ==================== Fare Rules for return flight =========================
  String? _onwardFareRulesContent;
  String? _returnFareRulesContent;

  String? get onwardFareRulesContent => _onwardFareRulesContent;
  String? get returnFareRulesContent => _returnFareRulesContent;

  Future<void> loadFareRulesForRoundTrip({
    required FlightDetail onwardFlight,
    required FlightDetail returnFlight
}) async {
    _isLoading = true;
    _error = null;
    _onwardFareRulesContent = null;
    _returnFareRulesContent = null;
    _onwardFareRulesError = null;
    _returnFareRulesError = null;
    notifyListeners();

    try {
      // Onward
      try {
        if (onwardFlight.source == 'TBO') {
          _onwardFareRulesContent = await repository.fetchTboFareRulesHtml(
            source: onwardFlight.source,
            traceId: onwardFlight.traceID,
            flightId: onwardFlight.flightID,
            resultIndex: onwardFlight.resultIndex,
          );
          _onwardFareRulesError = null;
        } else if (onwardFlight.source == 'AirIQ') {
          _onwardFareRulesContent = await repository.fetchAirIqFareRulesText(
            traceId: onwardFlight.traceID,
            flightIds: [onwardFlight.flightID],
          );
          _onwardFareRulesError = null;
        }
      }catch(e) {
        _onwardFareRulesError = e.toString();
        _onwardFareRulesContent = null;
      }

      // Return
      try {
        if (returnFlight.source == 'TBO') {
          _returnFareRulesContent = await repository.fetchTboFareRulesHtml(
            source: returnFlight.source,
            traceId: returnFlight.traceID,
            flightId: returnFlight.flightID,
            resultIndex: returnFlight.resultIndex,
          );
          _returnFareRulesError = null;
        } else if (returnFlight.source == 'AirIQ') {
          _returnFareRulesContent = await repository.fetchAirIqFareRulesText(
            traceId: returnFlight.traceID,
            flightIds: [returnFlight.flightID],
          );
          _returnFareRulesError = null;
        }
      }catch(e){
        _returnFareRulesError = e.toString();
        _returnFareRulesContent = null;
      }
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }


  // ==================== Baggage =========================
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


  String formatFareRulesHtml(String? html) {
    if (html == null || html.trim().isEmpty) {
      return "<p>No fare rules available</p>";
    }

    var unescape = HtmlUnescape();
    String formatted = unescape.convert(html.trim());

    // Remove <script> and <style> tags to avoid rendering issues
    formatted = formatted.replaceAll(
        RegExp(r'<script[^>]*>.*?</script>', dotAll: true), '');
    formatted = formatted.replaceAll(
        RegExp(r'<style[^>]*>.*?</style>', dotAll: true), '');

    // 2️⃣ Remove <img> tags completely
    formatted = formatted.replaceAll(
        RegExp(r'<img[^>]*>', caseSensitive: false), '');

    formatted = formatted.replaceAll(
        RegExp(r'<img[^>]*\/?>', caseSensitive: false), '');

    // Remove empty rows from tables
    formatted = formatted.replaceAll(
        RegExp(r'<tr>\s*<td[^>]*>\s*<\/td>.*?<\/tr>', dotAll: true), '');

    // Style tables for mobile view
    formatted = formatted.replaceAll(
        "<table",
        "<table border='1' style='border-collapse:collapse;width:100%;font-size:14px;'"
    );

    // Ensure html wrapper
    if (!formatted.toLowerCase().contains("<html")) {
      formatted = "<html><body>$formatted</body></html>";
    }
    AppLogger.log("Formatted HTML Data: $formatted");

    return formatted;
  }




  // String formatFareRulesHtml(String raw) {
  //   String withBreaks = raw.replaceAll('\n', '<br>');
  //   withBreaks = withBreaks.replaceAllMapped(RegExp(r'-{4,}'),
  //           (match) => '<br><br>');
  //   final bulletLines = withBreaks
  //       .split('*')
  //       .map((e) => e.trim())
  //       .where((e) => e.isNotEmpty)
  //       .toList();
  //   if (bulletLines.isEmpty) return withBreaks;
  //
  //   final buffer = StringBuffer('<ul>');
  //   for (var line in bulletLines) {
  //     buffer.write('<li>$line</li>');
  //   }
  //   buffer.write('</ul>');
  //   return buffer.toString();
  // }


  // ==================== Booking details =========================

  String _email = '';
  String _phone = '';

  String get email => _email;
  String get phone => _phone;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  bool validateBookingDetails(BuildContext context) {
    // ✅ Email required
    if (_email.trim().isEmpty) {
      _showError(context, 'Email is required.');
      return false;
    }

    // ( check email format)
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(_email.trim())) {
      _showError(context, 'Enter a valid email address.');
      return false;
    }

    // ( Phone required)
    if (_phone.trim().isEmpty) {
      _showError(context, 'Phone number is required.');
      return false;
    }

    // ( check phone length)
    if (_phone.trim().length < 6) {
      _showError(context, 'Enter a valid phone number.');
      return false;
    }

    return true;
  }


















  // ==================== Traveller details =========================
  final List<String> genderList = ['Male', 'Female', 'Other'];
  String _selectedGender = 'Male';
  String get selectedGender => _selectedGender;

  void setGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  String _firstName = '';
  String _lastName = '';
  DateTime? _dateOfBirth;
  String _passportNumber = '';
  DateTime? _passportExpiry ;



  String get firstName => _firstName;
  String get lastName => _lastName;
  DateTime? get dateOfBirth => _dateOfBirth;
  String get passportNumber => _passportNumber;
  DateTime? get passportExpiry => _passportExpiry;

  void setFirstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  void setDateOfBirth(DateTime date) {
    _dateOfBirth = date;
    notifyListeners();
  }

  void setPassportNumber(String value){
    _passportNumber = value;
    notifyListeners();
  }

  void setPassportExpiry(DateTime passportDate){
    _passportExpiry = passportDate;
    notifyListeners();
  }


  final List<TravellerInfo> _travellers = [];
  List<TravellerInfo> get travellers => List.unmodifiable(_travellers);


  bool addTraveller(BuildContext context, {
    required String type,
    required int typeLimit,
    required bool isPassportRequired,
  }) {
    final currentTypeCount = _travellers.where((t) => t.type == type).length;
    if (currentTypeCount >= typeLimit) {
      _showError(context, 'You can only add $typeLimit $type(s).');
      return false;
    }

    // Validation
    if (_firstName.trim().isEmpty) {
      _showError(context, 'First name is required.');
      return false;
    }

    if (_lastName.trim().isEmpty) {
      _showError(context, 'Last name is required.');
      return false;
    }

    if (_dateOfBirth == null) {
      _showError(context, 'Date of birth is required.');
      return false;
    }

    if (_selectedGender.trim().isEmpty) {
      _showError(context, 'Please select a gender.');
      return false;
    }

    if (isPassportRequired) {
      if (_passportNumber == null || _passportNumber.trim().isEmpty) {
        _showError(context, 'Passport number is required.');
        return false;
      }
      if (_passportExpiry == null) {
        _showError(context, 'Passport expiry date is required.');
        return false;
      }
    }

    // ✅ Add traveller
    _travellers.add(TravellerInfo(
      gender: _selectedGender,
      firstName: _firstName,
      lastName: _lastName,
      dateOfBirth: _dateOfBirth!,
      type: type,
      passportExpiry:_passportExpiry ,
      passportNumber: _passportNumber,
      selectedMeal: [],
      selectedBagg: [],
      selectedOther: []

    ));

    resetForm();
    notifyListeners();
    return true;
  }

  void clearTravellers() {
    _travellers.clear();
    notifyListeners();
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CustomDialogBox(
          title: "Field Required",
          descriptions: message,
          text: "OK",
          titleColor: kRedColor,
          img: 'images/dialog_error.png',
          functionCall: () {
            Navigator.of(ctx).pop(); // close dialog
          },
        );
      },
    );
  }


  void resetForm() {
    _selectedGender = genderList.first;
    _firstName = '';
    _lastName = '';
    _dateOfBirth = null;
    _passportNumber = '';
    _passportExpiry = null;
  }

  void removeTraveller(int index) {
    if (index >= 0 && index < _travellers.length) {
      _travellers.removeAt(index);
      notifyListeners();
    }
  }

  // ==================== Booking details =========================
  String _countryCode = '+91'; // default
  String get countryCode => _countryCode;

  void setCountryCode(String code) {
    _countryCode = code;
    notifyListeners();
  }


  // ==================== Payload OneWay  =========================

  Map<String, dynamic> buildBookingPayload({
    required FlightDetail flight,
    required SearchFlightProvider searchProvider,
}) {
    String formatDate(DateTime date){
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final yearTwoDigits = date.year.toString().substring(2);
      return "${date.day.toString().padLeft(2, '0')}-${months[date.month-1]}-$yearTwoDigits";
    }
    
    final fname = _travellers.map((t) => t.firstName).toList();
    final lname = _travellers.map((t) => t.lastName).toList();
    final gender = _travellers.map((t) => t.gender).toList();
    final dob = _travellers.map((t) => t.dateOfBirth.toIso8601String().split('T').first).toList();

    final passportNo = _travellers.map((t) => t.passportNumber).toList();
    final passportExpiry = _travellers.map((t) => t.passportExpiry?.toIso8601String().split('T').first).toList();

    String departureDate = formatDate(searchProvider.selectedDate);
    return {
      "f_destination" : flight.destination ?? '',
      "f_origin" : flight.origin ?? '',
      "date": departureDate,
      "adlt": searchProvider.adultCount.toString(),
      "child": searchProvider.childCount.toString(),
      "inft": searchProvider.infantCount.toString(),
      "email": _email,
      "phone": _phone,
      "country_code": _countryCode,
      "flight_type":  "oneway",
      "trace_id": flight.traceID,
      "result_index": flight.resultIndex,
      "fname": fname,
      "lname": lname,
      "gender": gender,
      "dob": dob,
      "passport_no": passportNo,
      "passport_expiry": passportExpiry,
    };
  }


  // ==================== Payload RoundTrip =========================

  Map<String, dynamic> buildRoundTripBookingPayload({
    required FlightDetail onwardFlight,
    required FlightDetail returnFlight,
    required SearchFlightProvider searchProvider,
  }) {
    String formatDate(DateTime date) {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final yearTwoDigits = date.year.toString().substring(2);
      return "${date.day.toString().padLeft(2, '0')}-${months[date.month - 1]}-$yearTwoDigits";
    }

    final fname = _travellers.map((t) => t.firstName).toList();
    final lname = _travellers.map((t) => t.lastName).toList();
    final gender = _travellers.map((t) => t.gender).toList();
    final dob = _travellers
        .map((t) => t.dateOfBirth.toIso8601String().split('T').first)
        .toList();
    final passportNo = _travellers.map((t) => t.passportNumber).toList();
    final passportExpiry = _travellers.map((t) => t.passportExpiry?.toIso8601String().split('T').first).toList();



    if (searchProvider.returnDate == null) {
      throw Exception('Return date is missing');
    }

    // ✅ format both dates
    final onwardDate = formatDate(searchProvider.selectedDate);
    final returnDate = formatDate(searchProvider.returnDate!);

    return {
      "f_destination": onwardFlight.destination ?? '',
      "f_origin": onwardFlight.origin ?? '',
      "date": onwardDate,
      "round_date": returnDate,
      "adlt": searchProvider.adultCount.toString(),
      "child": searchProvider.childCount.toString(),
      "inft": searchProvider.infantCount.toString(),
      "email": _email,
      "phone": _phone,
      "country_code": _countryCode,
      "flight_type": "roundTrip",
      "trace_id": onwardFlight.traceID,
      "result_index": onwardFlight.resultIndex,
      "result_index2": returnFlight.resultIndex,
      "fname": fname,
      "lname": lname,
      "gender": gender,
      "dob": dob,
      "passport_no": passportNo,
      "passport_expiry": passportExpiry,
    };
  }


  Future<Map<String, dynamic>> submitBookingData({
    required BuildContext context,
    required FlightDetail flight,
    required SearchFlightProvider searchProvider
}) async {
    if (!validateBookingDetails(context)) {
      throw Exception('Invalid booking details');
    }
    if (_travellers.isEmpty) {
      _showError(context, 'Please add at least one traveller.');
      throw Exception('No travellers added');
    }



    final totalRequired = searchProvider.adultCount +
        searchProvider.childCount +
        searchProvider.infantCount;

    if (_travellers.length != totalRequired) {
      _showError(
        context,
        'Total travellers (${_travellers.length}) must equal the total passenger count ($totalRequired).',
      );
      throw Exception('Traveller count mismatch');
    }

    final payload = buildBookingPayload(
      flight: flight,
      searchProvider: searchProvider
    );

    try{
      final response = await repository.submitBooking(payload);
      return response;
    }catch(e) {
      rethrow;
    }

  }


  Future<Map<String, dynamic>> submitRoundTripBookingData({
    required BuildContext context,
    required FlightDetail onwardFlight,
    required FlightDetail returnFlight,
    required SearchFlightProvider searchProvider,
  }) async {
    // 🔹 Validate basic details
    if (!validateBookingDetails(context)) {
      throw Exception('Invalid booking details');
    }
    if (_travellers.isEmpty) {
      _showError(context, 'Please add at least one traveller.');
      throw Exception('No travellers added');
    }


    final totalRequired = searchProvider.adultCount +
        searchProvider.childCount +
        searchProvider.infantCount;

    if (_travellers.length != totalRequired) {
      _showError(
        context,
        'Total travellers (${_travellers.length}) must equal the total passenger count ($totalRequired).',
      );
      throw Exception('Traveller count mismatch');
    }

    // 🔹 Build round trip payload
    final payload = buildRoundTripBookingPayload(
      onwardFlight: onwardFlight,
      returnFlight: returnFlight,
      searchProvider: searchProvider,
    );

    // 🔹 Submit to repository
    try {
      final response = await repository.submitBooking(payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }


}
