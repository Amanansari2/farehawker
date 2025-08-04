import 'package:flightbooking/repository/auth_repo.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flightbooking/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResetPasswordProvider  extends ChangeNotifier{

  final AuthRepository authRepository = AuthRepository();

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool hideCurrentPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;

  void toggleCurrentPassword() {
    hideCurrentPassword = !hideCurrentPassword;
    notifyListeners();
  }

  void toggleNewPassword() {
    hideNewPassword = !hideNewPassword;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    hideConfirmPassword = !hideConfirmPassword;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  void showValidationDialog(BuildContext context, String message, String title){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return CustomDialogBox(
            title: title,
            descriptions: message,
            text: "Ok",
            img: title == 'Success' ? 'images/dialog_success.png':'images/dialog_error.png',
            titleColor: title == "Success" ? kPrimaryColor : kRedColor,
            functionCall: (){
              Navigator.of(context).pop();
            },
          );
        });
  }
  
  Future<void> resetPassword(BuildContext context) async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    
    if(currentPassword.isEmpty){
      showValidationDialog(context, "Current password is required.", "Validation Error");
      return;
    }
    if(newPassword.isEmpty){
      showValidationDialog(context, "New password is required.", "Validation Error");
      return;
    }
    if(confirmPassword.isEmpty){
      showValidationDialog(context, "Confirm password is required", "Validation Error");
      return;
    }
    if(newPassword != confirmPassword){
      showValidationDialog(context, "New password and confirmation do not match. Please try again.", "Validation Error");
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try{
      final response = await authRepository.resetPassword(
          currentPassword,
          newPassword,
          confirmPassword
      );
      final status = response['status'];
      final code = response['code'];
      final message = response['message'] ?? "Something went Wrong. Please try again after sometime";

      if(status == 'success' && code == 200){
        _successMessage = message;
        showValidationDialog(context, message, "Success");
        clearFields();
      } else{
        _errorMessage = message;
        showValidationDialog(context, message, "Error");
      }
    }catch(e){
      _errorMessage = "Unexpected Error: ${e.toString()}";
      showValidationDialog(context, _errorMessage!, "Error");
    }finally{
      _isLoading = false;
      notifyListeners();
    }

  }
  
  void clearFields(){
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }
}