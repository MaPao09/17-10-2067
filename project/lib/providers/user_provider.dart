

import 'package:flutter/material.dart';
import 'package:project/model/user_model.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  String? _accessToken;
  String? _refreshToken;

  User get user => _user!;
  String get accessToken => _accessToken!;
  String get refreshToken => _refreshToken!;

  void onLogin(UserModel userModel) {
    //ไม่ได้ร้องขอ ไม่ต้องใส่async
    _user = userModel.user;
    _accessToken = userModel.accessToken;
    _refreshToken = userModel.refreshToken;
    notifyListeners();
  }

  void onLogout() {
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  void updateAccessToken(String newtoken) {
    _accessToken = newtoken;
    notifyListeners();
  }
}
