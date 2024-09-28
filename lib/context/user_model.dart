import 'package:erailpass_mobile/models/user.dart';
import 'package:erailpass_mobile/services/token_holder.dart';
import 'package:erailpass_mobile/services/user_service.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  User? _user;

  User? getUser({bool force=false}) {
    if(_user != null && !force) {
      return _user;
    }
    getUserFromApi().then((data) => {
      debugPrint("user received")
    });
    return null;
  }

  Future<User?> getUserFromApi() async {
    User? user = await UserService.getUser();
    _user = user;
    notifyListeners();
    return user;
  }

  Future<void> updateUser(User user) async {
    User? updatedUser = await UserService.updateUser(user);
    if(updatedUser != null) {
      _user = updatedUser;
      notifyListeners();
    }
  }

  Future<bool> register(User user, String password) async {
    String? token = await UserService.registerAndGetToken(user, password);
    if(token != null) {
      TokenHolder tokenHolder = TokenHolder();
      await tokenHolder.setToken(token);
      await getUserFromApi();
      return true;
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    String? token = await UserService.loginAndGetToken(email, password);
    if(token != null) {
      TokenHolder tokenHolder = TokenHolder();
      await tokenHolder.setToken(token);
      await getUserFromApi();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _user = null;
    TokenHolder tokenHolder = TokenHolder();
    await tokenHolder.clearToken();
    notifyListeners();
  }
}
