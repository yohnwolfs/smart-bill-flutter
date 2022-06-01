import 'dart:async';

import 'package:account_book/models/user.dart';

import '../constants.dart';
import '../http/base_dio.dart';

const scope = 'user';

TransformDio dio = BaseDio.instance.getDio();

class AuthDao {
  AuthDao._();

  static AuthDao? _instance;

  factory AuthDao() {
    return _instance ?? AuthDao._();
  }

  String get baseUrl => '${Config().apiUrl}/$scope';

  Future<User> login(Map<String, dynamic> params) async {
    dynamic res = await dio.post('$baseUrl/login', data: params);
    return User.fromJson(res);
  }

  Future<User> register(Map<String, dynamic> params) async {
    final res = await dio.post('$baseUrl/register', data: params);
    return User.fromJson(res);
  }

  Future<User> getUserData() async {
    final res = await dio.get('$baseUrl/userInfo');
    return User.fromJson(res);
  }

  Future<User> updateUser(String id, Map<String, dynamic> params) async {
    final res = await dio.post('$baseUrl/login', data: params);
    return User.fromJson(res);
  }

  Future<dynamic> changPwd(String newPwd) async {
    final res = await dio.post('$baseUrl/changPwd', data: {'password': newPwd});
    return res;
  }
}
