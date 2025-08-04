import 'package:flightbooking/api_services/configs/app_configs.dart';
import 'package:flightbooking/providers/login_provider.dart';
import 'package:flightbooking/repository/auth_repo.dart';
import 'package:flightbooking/routes/route_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class LogoutProvider extends ChangeNotifier{

  final AuthRepository _authRepository = AuthRepository();

  final box = GetStorage();

  bool isLoading = false;
  String? errorMessage;

  Map<String, String> get _logoutCurrentHeaders => {
    "action": "LogoutCurrent",
    "api-key": AppConfigs.apiKey,
  };

  /// Headers for logout all devices
  Map<String, String> get _logoutAllHeaders => {
    "action": "LogoutAll",
    "api-key": AppConfigs.apiKey,
  };


  Future<void> performLocalLogout(BuildContext context,) async {
    await box.remove('token');
    await box.remove('id');
    await box.remove('profile');
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    loginProvider.clearProfile();

    toast("Session expired. Please login again.");
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

Future<Map<String, dynamic>>logoutCurrentDevice(BuildContext context) async {
  isLoading = true;
  errorMessage= null;
  notifyListeners();
    try{
    final response = await _authRepository.logout(_logoutCurrentHeaders);
    final status = response['status']?.toString().toLowerCase();
    final message = response['message']?.toString() ?? "Logout Successful";
    if(status == 'success'){
      await box.remove('token');
      await box.remove('id');
      await box.remove('profile');
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      loginProvider.clearProfile();
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      toast(message);
         Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
    }else{
      if (message.toLowerCase().contains("invalid") ||
          message.toLowerCase().contains("expired")) {
        await performLocalLogout(context);
      } else {
        toast(response['message'] ?? "Logout Failed");
      }
    }
    isLoading = false;
    notifyListeners();
    return response;
  }catch(e){
    isLoading = false;
    errorMessage = e.toString();
    notifyListeners();
    rethrow;
  }
}

Future<Map<String, dynamic>> logoutAllDevices(BuildContext context) async {
  try{
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final response = await _authRepository.logout(_logoutAllHeaders);
    final status = response['status']?.toString().toLowerCase();
    final message = response['message']?.toString() ?? "logout Successful";
    if(status == 'success'){
      await box.remove('token');
      await box.remove('id');
      await box.remove('profile');
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      loginProvider.clearProfile();
      if(Navigator.of(context, rootNavigator: true).canPop()){
        Navigator.of(context, rootNavigator: true).pop();}
      toast(message);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
    } else{
      if (message.toLowerCase().contains("invalid") ||
          message.toLowerCase().contains("expired")) {
        await performLocalLogout(context);
      } else {
        toast(response['message'] ?? "Logout Failed");
      }
    }
    isLoading = false;
    notifyListeners();
    return response;
  }catch(e){
    isLoading = false;
    errorMessage = e.toString();
    notifyListeners();
    rethrow;
  }
}
}