import 'dart:convert';
import 'package:dio/dio.dart';
import 'error_interceptor.dart';
import 'header_interceptor.dart';

class BaseDio {
  BaseDio._();

  static BaseDio? _instance;

  static BaseDio get instance => _getInstance();

  static BaseDio _getInstance() {
    return _instance ?? BaseDio._();
  }

  factory BaseDio() => _getInstance();

  Dio getOriginalDio({String? baseUrl}) {
    final Dio dio = Dio();
    dio.options = BaseOptions(
        baseUrl: baseUrl ?? '',
        receiveTimeout: 66000,
        connectTimeout: 66000); // 设置超时时间等 ...
    dio.interceptors.add(HeaderInterceptor()); //
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors
        .add(InterceptorsWrapper(onResponse: (Response response) async {
      final data = response.data["data"];
      final code = response.data["code"];
      final message = response.data["message"];
      if (code == 0)
        return data;
      else
        return dio.reject(message);
    }));

    return dio;
  }

  TransformDio getDio({String? baseUrl}) {
    Dio originalDio = getOriginalDio(baseUrl: baseUrl);
    TransformDio dio = TransformDio(originalDio);
    return dio;
  }
}

class TransformDio {
  Dio dio;
  TransformDio(this.dio);

  dynamic get(String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      void Function(int, int)? onReceiveProgress}) async {
    final res = await dio.get(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);

    try {
      return jsonDecode(res.toString());
    } catch (e) {
      return res.data;
    }
  }

  dynamic put(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      void Function(int, int)? onSendProgress,
      void Function(int, int)? onReceiveProgress}) async {
    final res = await dio.put(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    try {
      return jsonDecode(res.toString());
    } catch (e) {
      return res.data;
    }
  }

  dynamic post(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      void Function(int, int)? onSendProgress,
      void Function(int, int)? onReceiveProgress}) async {
    final res = await dio.post(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    try {
      return jsonDecode(res.toString());
    } catch (e) {
      return res.data;
    }
  }

  dynamic delete(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) async {
    final res = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    try {
      return jsonDecode(res.toString());
    } catch (e) {
      return res.data;
    }
  }
}
