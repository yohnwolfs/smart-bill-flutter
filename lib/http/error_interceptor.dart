import 'dart:convert';

import 'package:account_book/navigator/navigation_util.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app_exceptions.dart';

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError err) {
    // 返回错误信息
    final message = err.response != null
        ? jsonDecode(jsonEncode(err.response?.data))['message']
        : err.message;

    // error统一处理
    AppException appException = AppException.create(err);

    // 未登录或没权限
    if (err.response?.statusCode == 401 &&
        NavigationUtil.getInstance().routeInfo?.currentRoute?.settings.name !=
            'login') {
      NavigationUtil.getInstance().pushReplacementNamed('login');
    }

    Fluttertoast.showToast(
        msg: message, timeInSecForIosWeb: 2, gravity: ToastGravity.CENTER);

    // 错误提示
    err.error = message != null
        ? UnauthorisedException(err.response?.statusCode, message)
        : appException;
    return super.onError(err);
  }
}
