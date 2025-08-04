
import 'package:flightbooking/api_services/app_logger.dart';
import 'package:flightbooking/api_services/configs/app_configs.dart';
import 'package:flightbooking/api_services/configs/urls.dart';
import 'package:flightbooking/generated/l10n.dart';
import 'package:get_storage/get_storage.dart';

import '../api_services/api_request/post_request.dart';
import '../models/login_model.dart';
import '../models/profile_model.dart';
import '../models/sign_up_model.dart';

class AuthRepository {
  final PostService _postService = PostService();
  final box = GetStorage();

  Future<Map<String, dynamic>> signUp(SignUpModel signUpData) async {
    try {
      final response = await _postService.postRequest(
        endPoint: register,
        body: signUpData.toJson(),
        requireAuth: false,
        customHeaders: {
          "action" : "Register",
          "api-key" : AppConfigs.apiKey
        }
      );
      return response;
    } catch (e) {
      throw Exception('Error during sign-up: $e');
    }
  }

  Future<Map<String, dynamic>> updateProfile(SignUpModel updateData) async{
    try{
      final response = await _postService.postRequest(
          endPoint: updateProfileUrl,
          body: updateData.toJson(),
          requireAuth: true,
        customHeaders: {
            "action" : "ProfileUpdate",
          "api-key" : AppConfigs.apiKey
        }
      );
      return response;
    } catch(e) {
      throw Exception("'Error during sign-up: $e");
    }
  }

  Future<LoginModel> signIn(String email, String password) async {
    try {
      final response = await _postService.postRequest(
        endPoint: login,
        body: {
          'email': email,
          'password': password,
        },
        requireAuth: false,
        customHeaders: {
          "action": "Login",
          "api-key": AppConfigs.apiKey,
        },
      );

      if (response['status'] == 'success') {

        return LoginModel.fromJson(response);
      } else {
        final dynamic message = response['message'] ?? 'Login failed';
        throw Exception(message is List ? message.join(", ") : message.toString());
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }



  Future<ProfileModel> getProfile(int id) async {
    try {

      final response = await _postService.postRequest(
        endPoint: getUserProfile,
        requireAuth: true,
        customHeaders: {
          "action": "Profile",
          "api-key": AppConfigs.apiKey,
        },
        body: {"id": id},
      );

      if (response['status'] == 'success') {
        return ProfileModel.fromJson(response['data']);
      } else {
        final message = response['message']?.toString() ?? 'Failed to fetch profile';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  Future<Map<String, dynamic>> logout(Map<String, String> headers) async{
    try{
      final response = await _postService.postRequest(
          endPoint: updateProfileUrl,
          body: {},
          requireAuth: true,
          customHeaders: headers,
      );
      return response;
    } catch(e) {
      throw Exception("'Error during sign-up: $e");
    }
  }


  Future<Map<String, dynamic>> resetPassword(String currentPassword, String newPassword, String confirmPassword) async{
    try{
      final response = await _postService.postRequest(
          endPoint: changePassword,
          body: {
            "CurrentPassword" : currentPassword,
            "NewPassword" : newPassword,
            "ConfirmPassword" : confirmPassword
          },
      requireAuth: true,
        customHeaders: {
          "action": "ChangePassword",
          "api-key": AppConfigs.apiKey,
        }
      );
      return response;
    } catch (e) {
      throw Exception("Error during resetPassword $e");
    }
  }


  Future<Map<String, dynamic>> forgetPassword(String email) async {
    try{
      final response = await _postService.postRequest(
          endPoint: forgotPasswordUrl,
          body: {
            'email' : email
          },
      requireAuth: false,
        customHeaders: {
          "action": "forgotPassword",
          "api-key": AppConfigs.apiKey,
        }
      );
      return response;
    } catch(e){
      throw Exception("Error sending password reset link $e");
    }
  }
}
