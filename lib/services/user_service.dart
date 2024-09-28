import 'package:dio/dio.dart';
import 'package:erailpass_mobile/common/custom_dio.dart';
import 'package:erailpass_mobile/common/toast.dart';
import 'package:erailpass_mobile/models/app_response.dart';
import 'package:erailpass_mobile/models/user.dart';
import 'package:flutter/cupertino.dart';

class UserService {
  
  static Future<User?> getUser() async {

      String url = getApiUrl("auth/me");
      Response<dynamic> response = await customDio.get(url);
      AppResponse<Map<String, dynamic>> appResponse = AppResponse.fromJson(response);
      if(appResponse.success) {
        return User.fromJson(appResponse.data!);
      } else {
        showToast("Failed to get user");
        return null;
      }
  }

  static Future<User?> updateUser(User user) async {
    Map<String, dynamic> data = user.toJson();

    String url = getApiUrl("auth/me/update");
    Response<dynamic> response = await customDio.post(url, data: data);
    debugPrint(response.toString());
    AppResponse<Map<String, dynamic>> appResponse = AppResponse.fromJson(response);
    if(appResponse.success) {
      return User.fromJson(appResponse.data!);
    } else {
      showToast("Failed to update user");
      return null;
    }
  }

  static Future<String?> registerAndGetToken(User user, String password) async {
    Map<String, dynamic> data = user.toJson();
    data['password'] = password;
    data.removeWhere((String key, dynamic value)=> key=='_id');

    String url = getApiUrl("public/register");
    Response<dynamic> response = await customDio.post(url, data: data);
    debugPrint(response.toString());
    AppResponse<String> appResponse = AppResponse.fromJson(response);
    if(appResponse.success) {
      return appResponse.data!;
    } else {
      showToast(appResponse.message ?? "Failed to register user");
      return null;
    }
  }

  static Future<String?> loginAndGetToken(String email, String password) async {
    Map<String, dynamic> data = {
      "email": email,
      "password": password,
    };
    String url = getApiUrl("public/login");
    Response<dynamic> response = await customDio.post(url, data: data);
    debugPrint(response.toString());
    AppResponse<String> appResponse = AppResponse.fromJson(response);
    if(appResponse.success) {
      return appResponse.data!;
    } else {
      showToast("Failed to login user");
      return null;
    }
  }

}
