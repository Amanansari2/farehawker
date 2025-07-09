// import 'package:flightbooking/repository/auth_repo.dart';
// import 'package:flutter/cupertino.dart';
//
// class AuthController extends ChangeNotifier{
//   final AuthRepository _authRepository = AuthRepository();
//
//   bool _isAuthenticated = false;
//   bool get isAuthenticated => _isAuthenticated;
//
//   Future<void> initAuth() async {
//     _isAuthenticated = await _authRepository.loginIfNeeded();
//     notifyListeners();
//   }
// }