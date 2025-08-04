import 'package:flightbooking/repository/auth_repo.dart';
import 'package:flightbooking/routes/route_generator.dart';
import 'package:flightbooking/widgets/constant.dart';
import 'package:flightbooking/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordProvider extends ChangeNotifier{

  final AuthRepository authRepository = AuthRepository();

  TextEditingController emailController = TextEditingController();

 bool _isLoading = false;
 bool get isLoading => _isLoading;

 String? _errorMessage;
 String? get errorMessage => _errorMessage;

 String? _successMessage;
 String? get  successMessage => _successMessage;

 Future<void> showValidationDialog(BuildContext context, String message, String title)async {
  return showDialog(
     barrierDismissible: false,
       context: context,
       builder: (BuildContext context){
         return CustomDialogBox(
           title: title,
           descriptions:  message,
           text: "ok",
           img : title == 'Success' ? 'images/dialog_success.png' : 'images/dialog_error.png',
           titleColor:  title == "Success" ? kPrimaryColor : kRedColor,
           functionCall: (){
             Navigator.of(context).pop();
           },
         );
       });

 }

  Future<void> forgotPassword(BuildContext context) async {
    final email = emailController.text.trim();

    if(email.isEmpty){
      showValidationDialog(context, "Email is required.", "Validation Error");
      return;
    }

    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      showValidationDialog(context, "Please enter correct email.", "Validation Error");
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try{
      final response = await authRepository.forgetPassword(email);

      final status = response['status'];
      final code = response['code'];
      final message = response['message']?? 'Something went wrong. Please try again later';

      if(status == 'success' && code == 200){
        emailController.clear();
        _successMessage = message;
        await showValidationDialog(context, message, "Success");
        Navigator.pushNamed(context, AppRoutes.login);
      }else{
        _errorMessage =message;
        showValidationDialog(context, message, "Error");
      }
    }catch(e){
      _errorMessage = "unexpected Error : ${e.toString()}";
      showValidationDialog(context, _errorMessage!, "Error");
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

}
