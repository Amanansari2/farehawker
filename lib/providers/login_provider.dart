import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/models/login_model.dart';
import 'package:flightbooking/repository/auth_repo.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flightbooking/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'logout_provider.dart';

class LoginProvider extends ChangeNotifier{
  final AuthRepository _repository = AuthRepository();

  final box = GetStorage();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;
  LoginModel? _loginData;
  bool _isLoading = false;
  String ? _errorMessage;

  LoginModel? get loginData => _loginData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void togglePassword() {
    hidePassword = !hidePassword;
    notifyListeners();
  }





  void _showDialog(BuildContext context, String  title, String description) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialogBox(
            title: title,
            descriptions: description,
            text: "Ok",
            img: "images/dialog_error.png",
            titleColor: kRedColor,
            functionCall: (){
              Navigator.pop(context);
            },
          );
        });
  }

  Future<void> signIn(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email.isEmpty){
      _showDialog(context, "validation Error", "Please enter your email");
      return;
    }

    if(password.isEmpty){
      _showDialog(context, "Validation Error", "Please enter your password");
      return;
    }

    _isLoading = true;
     _errorMessage = null;
    notifyListeners();

    try{
      _loginData = await _repository.signIn(email, password);

      if (_loginData != null) {
        await box.write('token', _loginData!.token);
        await box.write('id', _loginData!.id);

        AppLogger.log("User stored successfully!");
       fetchAndStoreProfile(_loginData!.id);
      }

    }catch(e, stackTrace){
      _errorMessage = e.toString();
      _loginData = null;
      AppLogger.log("Login Error: $e\n$stackTrace");

      String cleanMessage = _errorMessage!
          .replaceFirst("Exception: ", "")
          .replaceAll("[", "")
          .replaceAll("]", "");
      _showDialog(context, "Login Failed", cleanMessage);
    }
    _isLoading = false;
    notifyListeners();
  }



  // Future<void> fetchAndStoreProfile(int userId) async {
  //   try {
  //     final profileData = await _repository.getProfile(userId);
  //
  //     await box.write('profile', profileData.toJson());
  //
  //     _user = profileData.toJson();
  //     notifyListeners();
  //
  //     AppLogger.log("Profile fetched & stored successfully!");
  //
  //   } catch (e) {
  //     AppLogger.log("Background Profile Fetch Failed: $e");
  //   }
  // }

  Future<bool> fetchAndStoreProfile(int userId, {BuildContext? context}) async {
    try {
      final profileData = await _repository.getProfile(userId);

      // Save profile to local storage
      await box.write('profile', profileData.toJson());

      // Update provider state
      _user = profileData.toJson();
      notifyListeners();

      AppLogger.log("Profile fetched & stored successfully!");
      return true; // success
    } catch (e) {
      // Clean and normalize error
      final errorMessage = e.toString()
          .replaceFirst('Exception: ', '')
          .trim()
          .toLowerCase();

      AppLogger.log("Background Profile Fetch Failed: $errorMessage");

      // If token is invalid/expired → logout
      if (errorMessage.contains('expired') || errorMessage.contains('invalid')) {
        if (context != null && context.mounted) {

            final logoutProvider = Provider.of<LogoutProvider>(context, listen: false);
            await logoutProvider.performLocalLogout(context);
        }
        return false;
      }

      return false;
    }
  }


  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  LoginProvider() {
    loadUser();
  }

  void loadUser() {
    _user = box.read('profile');
    notifyListeners();
  }

  void clearProfile() {
    _loginData = null;
    _user = null;
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  void updateUser(Map<String, dynamic> newUser) {
    _user = newUser;
    box.write('profile', newUser);
    notifyListeners();
  }

}