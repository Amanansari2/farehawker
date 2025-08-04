import 'package:flightbooking/screen/Authentication/login_screen.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flightbooking/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/sign_up_model.dart';
import '../repository/auth_repo.dart';

class SignUpProvider extends ChangeNotifier {

  final AuthRepository _signUpRepository = AuthRepository();


  // Form controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passportNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  DateTime? passportExpiryDate;
  bool hidePassword = true;
  bool hideConfirmPassword = true;


  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;


  String get formattedPassportExpiryDate {
    if (passportExpiryDate != null) {
      return DateFormat('yyyy-MM-dd').format(passportExpiryDate!);
    }
    return 'Select Expiry Date';
  }

  DateTime? _dateOfBirth;

  DateTime? get dateOfBirth => _dateOfBirth;

  void setDateOfBirth(DateTime date) {
    _dateOfBirth = date;
    notifyListeners();
  }

  String get formattedDateOfBirth {
    if (_dateOfBirth != null) {
      return DateFormat('yyyy-MM-dd').format(_dateOfBirth!);
    }
    return 'Select Date of Birth';
  }

  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: currentDate,
    );
    if (picked != null && picked != _dateOfBirth) {
      setDateOfBirth(picked);
      notifyListeners();
    }
  }

  Map<String, String> genderOptions = {
    'Male': 'Male',
    'Female': 'Female',
    'Other': 'Other',
  };

  String _selectedGender = 'Male';

  String get selectedGender => _selectedGender;

  void setGender(String gender) {
    if (genderOptions.containsKey(gender)) {
      _selectedGender = gender;
      notifyListeners();
    }
  }

  // Toggling password visibility
  void togglePasswordVisibility() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    hideConfirmPassword = !hideConfirmPassword;
    notifyListeners();
  }

  // Handle the Passport Expiry Date picker
  Future<void> selectExpiryDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != passportExpiryDate) {
      passportExpiryDate = picked;
      notifyListeners();
    }
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
          titleColor: kRedColor,
          functionCall: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  bool validateField(BuildContext context, TextEditingController controller,
      String fieldName, {bool isEmail = false}) {
    if (controller.text.isEmpty) {
      showValidationDialog(context, '$fieldName is required.');
      return false;
    }

    if (isEmail) {
      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(
          controller.text)) {
        showValidationDialog(context, 'Please enter a valid email address.');
        return false; // Return false if the email format is invalid
      }
    }

    return true;
  }


  Future<void> submitSignUpForm(BuildContext context) async {
    if (!validateField(context, firstNameController, "First Name")) return;
    if (!validateField(context, lastNameController, "Last Name")) return;
    if (!validateField(context, emailController, "Email", isEmail: true))
      return;
    if (!validateField(context, phoneController, "Phone Number")) return;
    if (_dateOfBirth == null) {
      showValidationDialog(context, "Date of birth is required.");
      return;
    }

    if (!validateField(context, passwordController, "Password")) return;
    if (!validateField(context, confirmPasswordController, "Confirm Password"))
      return;


    if (passwordController.text != confirmPasswordController.text) {
      showValidationDialog(context, "Passwords do not match.");
      return;
    }


    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final signUpData = SignUpModel(
        name: firstNameController.text,
        lname: lastNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        passportNo: passportNumberController.text,
        passportExpiry: passportExpiryDate != null
                        ? DateFormat('yyyy-MM-dd').format(passportExpiryDate!)
                         : '',
        dob: _dateOfBirth != null
            ? DateFormat('yyyy-MM-dd').format(_dateOfBirth!)
            : '',
        gender: _selectedGender,
      );

      final response = await _signUpRepository.signUp(signUpData);

      if (response['status'] == 'success') {
        _isLoading = false;
        notifyListeners();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: "Sign Up Successful",
                descriptions: response['message'],
                text: "ok",
                img: "images/dialog_success.png",
                titleColor: kPrimaryColor,
                functionCall: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LogIn()));
                },
              );
            });
      } else {
        _error = response['message'];
        _isLoading = false;
        notifyListeners();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Sign Up Failed",
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
    } catch (e) {
      _error = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
