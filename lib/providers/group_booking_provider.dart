import 'package:flightbooking/api_services/api_request/post_request.dart';
import 'package:flightbooking/api_services/configs/urls.dart';
import 'package:flutter/material.dart';

import '../api_services/app_logger.dart';
import '../api_services/configs/app_configs.dart';
import '../models/country_list_model.dart';


class GroupBookingProvider extends ChangeNotifier {

  final PostService postService = PostService();

  final TextEditingController adultCountController = TextEditingController();
  final TextEditingController childCountController = TextEditingController();
  final TextEditingController infantCountController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();


  int selectedGroupTripIndex = 0;
  bool isLoading = false;
  City? fromCity;
  City? toCity;
  String validationMessage = '';
  DateTime selectedDate = DateTime.now();
  DateTime? returnDate;



  String get returnDateTitle => returnDate != null ? _formatDate(returnDate!) : 'Select Return Date';
  String get departureDateTitle => _formatDate(selectedDate);

  bool setDate(DateTime dt) {
    if (dt.isBefore(DateTime.now().subtract(const Duration(days:1)))) {
      validationMessage = 'You cannot select a past date';
      notifyListeners();
      return false;
    } else {
      selectedDate = dt;
      validationMessage = '';
      notifyListeners();
      return true;
    }
  }

  bool setReturnDate(DateTime dt) {
    if (dt.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      validationMessage = 'You cannot select a past date';
      notifyListeners();
      return false;
    }else {
      returnDate = dt;
      validationMessage = '';
      notifyListeners();
      return true;
    }
  }

  String _formatDate(DateTime dt)  {
    final day = dt.day.toString().padLeft(2, '0');
    final month = ["jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"][dt.month - 1];
    final year = dt.year.toString().substring(2);
    return '$day-$month-$year';
  }





  void setTripIndex(int index) {
    selectedGroupTripIndex = index;
    AppLogger.log("Selected Index -->> $selectedGroupTripIndex");
    notifyListeners();
  }

  void setFromCity(City city) {
    fromCity = city;
    notifyListeners();
  }

  void setToCity(City city){
    toCity = city;
    notifyListeners();
  }

  Map<String, dynamic> payload() {
    return {
      'trip_type': selectedGroupTripIndex == 0 ? 'oneway' : 'round',
      'from': fromCity!.cityCode,
      'to': toCity!.cityCode,
      'depart': departureDateTitle,
      'return': selectedGroupTripIndex == 1 ? returnDateTitle : null ,
      'adult': adultCountController.text.trim(),
      'child': childCountController.text.trim(),
      'infant': infantCountController.text.trim(),
      'name': fullNameController.text.trim(),
      'contact': contactController.text.trim(),
      'email': emailController.text.trim(),
    };
    }

    Future<Map<String, dynamic>> submitGroupBooking() async {
    isLoading = true;
    notifyListeners();

    final response = await postService.postRequest(
        endPoint: groupBooking,
        body: payload(),
      customHeaders: {
        'action': 'Insert',
        'api-key': AppConfigs.apiKey,
      }
    );

    isLoading = false;
    notifyListeners();

    return response;


    }

  void resetForm() {
    adultCountController.clear();
    childCountController.clear();
    infantCountController.clear();
    fullNameController.clear();
    contactController.clear();
    emailController.clear();
    selectedGroupTripIndex = 0;
    selectedDate = DateTime.now();
    returnDate = null;
    validationMessage = '';
    notifyListeners();
  }



}
