import 'package:account_book/dao/auth_dao.dart';
import 'package:account_book/models/user.dart';
import 'package:account_book/navigator/navigation_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_util/sp_util.dart';

class AuthState extends ChangeNotifier {
  bool isLogin = false;

  User? get userInfo {
    final temp = SpUtil.getObject('user_info');
    return temp != null
        ? User.fromJson(temp as Map<String, dynamic>? ?? {})
        : null;
  }

  set userInfo(User? u) {
    if (u != null)
      SpUtil.putObject('user_info', u);
    else
      SpUtil.remove('user_info');
    notifyListeners();
  }

  String? get token => SpUtil.getString('token');

  Future<User?> getUserInfo() async {
    final _userData;
    try {
      _userData = await AuthDao().getUserData();
      userInfo = _userData;
      isLogin = true;
      return _userData;
    } on DioError {
      isLogin = false;
    }
    return null;
  }

  Future<User> login(String? userName, String? password) async {
    User _userData =
        await AuthDao().login({'name': userName, 'password': password});

    if (_userData.token is String) SpUtil.putString('token', _userData.token!);

    isLogin = true;
    userInfo = _userData;

    notifyListeners();
    return _userData;
  }

  Future<void> logout() async {
    isLogin = false;
    userInfo = null;
    SpUtil.remove('token');
    NavigationUtil.getInstance().pushReplacementNamed('login');
    notifyListeners();
    return;
  }
}
