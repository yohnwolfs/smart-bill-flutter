import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';

class HeaderInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    String? token = SpUtil.getString('token');
    String? authorization = 'Bearer $token';

    options.headers.addAll({'Authorization': authorization});

    return options;
  }
}
