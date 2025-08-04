import 'dart:math';

import 'package:flightbooking/routes/route_generator.dart';
import 'package:flightbooking/screen/profile/profile_screen.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/sign_up_model.dart';
import '../repository/auth_repo.dart';
import '../widgets/custom_dialog.dart';
import 'login_provider.dart';
import 'logout_provider.dart';

class UpdateProfileProvider extends ChangeNotifier{
  final AuthRepository _updateRepository = AuthRepository();



  TextEditingController updateFirstNameController = TextEditingController();
  TextEditingController updateLastNameController = TextEditingController();
  TextEditingController updateEmailController = TextEditingController();
  TextEditingController updatePhoneController = TextEditingController();
  TextEditingController updatePassportNumberController = TextEditingController();


  DateTime? updatePassportExpiryDate;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;




  DateTime? _updateDateOfBirth;

  DateTime? get updateDateOfBirth => _updateDateOfBirth;

  void setUpdateDateOfBirth(DateTime date) {
    _updateDateOfBirth = date;
    notifyListeners();
  }


  String get updateFormattedDateOfBirth {
    if(_updateDateOfBirth != null){
      return DateFormat('yyyy-MM-dd').format(_updateDateOfBirth!);
    }
    return 'Select Date of Birth';
  }


  Future<void> selectUpdateDateOfBirth(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1940),
        lastDate: currentDate
    );
    if(picked != null && picked != _updateDateOfBirth){
      setUpdateDateOfBirth(picked);
    }
  }

 String get updateFormattedPassportExpiryDate{
    if(updatePassportExpiryDate != null){
      return DateFormat('yyyy-MM-DD').format(updatePassportExpiryDate!);
    }
    return 'Select Expiry Date';
 }

  Map<String, String> updateGenderOptions = {
    'Male': 'Male',
    'Female': 'Female',
    'Other': 'Other',
  };

  String _updateSelectedGender = 'Male';
  String get updateSelectedGender => _updateSelectedGender;

  void setUpdateGender (String gender) {
    if(updateGenderOptions.containsKey(gender)){
      _updateSelectedGender = gender;
      notifyListeners();
    }
  }





  Future<void> updateSelectExpiryDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: currentDate,
        lastDate: DateTime(2100)
    );
    if(picked != null && picked != updatePassportExpiryDate){
      updatePassportExpiryDate = picked;
      notifyListeners();
    }
  }

  void prefillProfileData(Map<String, dynamic> profileData) {
    updateFirstNameController.text = profileData['name'] ?? '';
    updateLastNameController.text = profileData['lname'] ?? '';
    updateEmailController.text = profileData['email'] ?? '';
    updatePhoneController.text = profileData['phone'] ?? '';
    updatePassportNumberController.text = profileData['passport_no'] ?? '';


    // Gender
    if (profileData['gender'] != null && updateGenderOptions.containsKey(profileData['gender'])) {
      _updateSelectedGender = profileData['gender'];
    }

    if (profileData['dob'] != null && profileData['dob'].isNotEmpty) {
      try {
        _updateDateOfBirth = DateTime.parse(profileData['dob']);
      } catch (_) {}
    }

    if (profileData['passport_expiry'] != null && profileData['passport_expiry'].isNotEmpty) {
      try {
        updatePassportExpiryDate = DateTime.parse(profileData['passport_expiry']);
      } catch (_) {}
    }

    notifyListeners();
  }


  void showValidationDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: "Validation Error",
          descriptions: message,
          text: "OK",
          img: 'images/dialog_error.png',
          titleColor: Colors.red,
          functionCall: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  bool validateField(BuildContext context, TextEditingController controller, String fieldName, {bool isEmail = false}) {
    if (controller.text.isEmpty) {
      showValidationDialog(context, '$fieldName is required.');
      return false;
    }

    if (isEmail) {
      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(controller.text)) {
        showValidationDialog(context, 'Please enter a valid email address.');
        return false;
      }
    }

    return true;
  }


  Future<void> submitUpdateSignUpForm(BuildContext context) async {
    if (!validateField(context, updateFirstNameController, "First Name")) return;
    if (!validateField(context, updateLastNameController, "Last Name")) return;
    if (!validateField(context, updateEmailController, "Email", isEmail: true)) return;
    if (!validateField(context, updatePhoneController, "Phone Number")) return;
    if (_updateDateOfBirth == null) {
      showValidationDialog(context, "Date of birth is required.");
      return;
    }


    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final int? userId = loginProvider.user?['id'];
      if (userId == null) {
        showValidationDialog(context, "User ID not found. Please log in again.");
        _isLoading = false;
        return;
      }
      final updateData = SignUpModel(
        id: userId,
        name: updateFirstNameController.text,
        lname: updateLastNameController.text,
        email: updateEmailController.text,
        phone: updatePhoneController.text,
        passportNo: updatePassportNumberController.text,
        passportExpiry: updatePassportExpiryDate != null ? updatePassportExpiryDate!.toIso8601String() : '',
        dob:  _updateDateOfBirth != null
            ? DateFormat('yyyy-MM-dd').format(_updateDateOfBirth!)
            : '',
        gender: _updateSelectedGender,
      );

      final response = await _updateRepository.updateProfile(updateData);
      final message = response['message']?.toString() ?? 'Unknown error';
      if (message.toLowerCase().contains('invalid') ||
          message.toLowerCase().contains('expired')) {
        final logoutProvider =
        Provider.of<LogoutProvider>(context, listen: false);
        await logoutProvider.performLocalLogout(context);
        _isLoading = false;
        notifyListeners();
        return;
      }
      if(response['status'] == 'success'){
        _isLoading = false;
        notifyListeners();
        await loginProvider.fetchAndStoreProfile(userId);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: "Profile Update Successful",
                descriptions: response['message'],
                text: "ok",
                img: "images/dialog_success.png",
                titleColor: kPrimaryColor,
                functionCall: (){
                  Navigator.pop(context);
                },
              );
            });
      } else {
        _error = response['message'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Profile Update Failed",
              descriptions: response['message'],
              text: "OK",
              img: 'images/dialog_error.png',
              titleColor: Colors.red,
              functionCall: () {

                Navigator.of(context).pop();
              },
            );
          },
        );
      }
      } catch(e) {
      _error = 'An error occurred : $e';
    }finally{
      _isLoading = false;
      notifyListeners();
    }

    }

}