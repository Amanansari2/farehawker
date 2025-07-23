import 'package:flightbooking/providers/search_flight_provider.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  // ==================== Passport details =========================

  String _passportNumber = '';
  DateTime? _passportExpiry ;

  String get passportNumber => _passportNumber;
  DateTime? get passportExpiry => _passportExpiry;


  void setPassportNumber(String value){
    _passportNumber = value;
    notifyListeners();
  }


  void setPassportExpiry(DateTime passportDate){
    _passportExpiry = passportDate;
    notifyListeners();
  }
  final List<PassportInfo> _passports = [];
  List<PassportInfo> get passports => List.unmodifiable(_passports);

  bool addPassport(BuildContext context, {int? maxPassports}) {

    if (maxPassports != null && _passports.length >= maxPassports) {
      _showPassportError(context, 'You can add up to $maxPassports passports only.');
      return false;
    }

    // Validation
    if (_passportNumber.trim().isEmpty) {
      _showPassportError(context, 'Passport Number is required.');
      return false;
    }


    if (_passportExpiry == null) {
      _showPassportError(context, 'Passport Expiry is required.');
      return false;
    }


    // ✅ Add passport
    _passports.add(PassportInfo(
      passportNumber: _passportNumber,
      passportExpiry: _passportExpiry!
    ));

    resetPassportForm();
    notifyListeners();
    return true;
  }

  void _showPassportError(BuildContext context, String message) {
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


  void resetPassportForm() {
    _passportNumber = '';
    _passportExpiry = null;
  }

  void removePassport(int index) {
    if (index >= 0 && index < _passports.length) {
      _passports.removeAt(index);
      notifyListeners();
    }
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

  String get firstName => _firstName;
  String get lastName => _lastName;
  DateTime? get dateOfBirth => _dateOfBirth;

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


  final List<TravellerInfo> _travellers = [];
  List<TravellerInfo> get travellers => List.unmodifiable(_travellers);


  bool addTraveller(BuildContext context, {int? maxTravellers}) {

    if (maxTravellers != null && _travellers.length >= maxTravellers) {
      _showError(context, 'You can add up to $maxTravellers travellers only.');
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

    // ✅ Add traveller
    _travellers.add(TravellerInfo(
      gender: _selectedGender,
      firstName: _firstName,
      lastName: _lastName,
      dateOfBirth: _dateOfBirth!,
    ));

    resetForm();
    notifyListeners();
    return true;
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

    final passportNo = _passports.map((p) => p.passportNumber).toList();
    final passportExpiry = _passports.map((p) {
      return DateFormat('yyyy-MM-dd').format(p.passportExpiry);
    }).toList();

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

    if (_passports.length != _travellers.length) {
      _showPassportError(context,
          'Total passports (${_passports.length}) must equal the total passenger count (${_travellers.length}).');
      throw Exception('Passport count mismatch');
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

}
