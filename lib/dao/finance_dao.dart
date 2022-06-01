import 'dart:async';

import 'package:account_book/models/finance.dart';
import 'package:account_book/models/list.dart';
import 'package:dio/dio.dart';

import '../constants.dart';
import '../http/base_dio.dart';

const scope = 'finance';

TransformDio dio = BaseDio.instance.getDio();

class FinanceDao {
  FinanceDao._();

  static FinanceDao? _instance;

  factory FinanceDao() {
    return _instance ?? FinanceDao._();
  }

  String get baseUrl => '${Config().apiUrl}/$scope';

  Future<ListModel<FinanceBook>> getFinanceBooks(
      [Map<String, dynamic>? params]) async {
    final res = await dio.get('$baseUrl/books', queryParameters: params);
    return ListModel<FinanceBook>.fromJson(res);
  }

  Future<ListModel<Finance>> getFinances([Map<String, dynamic>? params]) async {
    final res = await dio.get('$baseUrl', queryParameters: params);
    return ListModel<Finance>.fromJson(res);
  }

  Future<StatisticsData> getFinanceStatistics(
      int startStamp, int endStamp) async {
    final res = await dio.get('$baseUrl/statistics', queryParameters: {
      'startStamp': startStamp,
      'endStamp': endStamp,
    });

    List<List<String>> finances =
        List.from(res['finances'].map((item) => List<String>.from(item)));
    List<TagStatistic> tags =
        List.from(res['tags'].map((item) => TagStatistic.fromJson(item)));

    return StatisticsData(finances, tags);
  }

  Future<Finance> getFinanceDetail(String id) async {
    final res = await dio.get('$baseUrl/$id');
    return Finance.fromJson(res);
  }

  Future<FinanceBook> getFinanceBookDetail(String id) async {
    final res = await dio.get('$baseUrl/books/$id');
    return FinanceBook.fromJson(res);
  }

  Future<List<FinanceTag>> getFinanceTags() async {
    final res = await dio.get('$baseUrl/tags');
    return res.map<FinanceTag>((item) => FinanceTag.fromJson(item)).toList();
  }

  Future<FinanceBook> addFinanceBook(Map<String, dynamic> params) async {
    final res = await dio.post('$baseUrl/books', data: params);
    return FinanceBook.fromJson(res);
  }

  Future<Finance> addFinance(Map<String, dynamic> params) async {
    final res = await dio.post('$baseUrl', data: params);
    return Finance.fromJson(res);
  }

  Future<FinanceTag> addFinanceTag(Map<String, dynamic> params) async {
    final file = params['icon'];
    var name = file != null
        ? file.path.substring(file.path.lastIndexOf("/") + 1, file.path.length)
        : null;
    FormData formData = FormData.fromMap({
      "name": params['name'],
      "type": params['type'],
      ...(params['order'] == null ? {} : {"order": params['order']}),
      ...(file == null
          ? {}
          : {"icon": await MultipartFile.fromFile(file.path, filename: name)})
    });
    final res = await dio.post('$baseUrl/tags', data: formData);

    return FinanceTag.fromJson(res);
  }

  Future<FinanceTag> updateFinanceTag(
      String id, Map<String, dynamic> params) async {
    final file = params['icon'];
    var name = file != null
        ? file.path.substring(file.path.lastIndexOf("/") + 1, file.path.length)
        : null;
    FormData formData = FormData.fromMap({
      "name": params['name'],
      "type": params['type'],
      ...(params['order'] == null ? {} : {"order": params['order']}),
      ...(file == null
          ? {}
          : {"icon": await MultipartFile.fromFile(file.path, filename: name)})
    });
    final res = await dio.put('$baseUrl/tags/$id', data: formData);

    return FinanceTag.fromJson(res);
  }

  Future<Finance> updateFinance(String id, Map<String, dynamic> params) async {
    final res = await dio.put('$baseUrl/$id', data: params);
    return Finance.fromJson(res);
  }

  Future<FinanceBook> updateFinacneBook(
      String id, Map<String, dynamic> params) async {
    final res = await dio.put('$baseUrl/books/$id', data: params);
    return FinanceBook.fromJson(res);
  }

  Future<dynamic> updateFinanceBookBg(String id, FormData data) async {
    final res = await dio.put('$baseUrl/books/$id/changeBg', data: data);
    return FinanceBook.fromJson(res);
  }

  Future<List<FinanceBook>> deleteFinanceBook(List<String> ids) async {
    final res = await dio.delete('$baseUrl/books', data: ids);
    return res.map<FinanceBook>((item) => FinanceBook.fromJson(item)).toList();
  }

  Future<List<Finance>> deleteFinance(List<String> ids) async {
    final res = await dio.delete('$baseUrl', data: ids);
    return res.map<Finance>((item) => Finance.fromJson(item)).toList();
  }

  Future<List<FinanceTag>> deleteFinanceTags(List<String> ids) async {
    final res = await dio.delete('$baseUrl/tags', data: ids);
    return res.map<FinanceTag>((item) => FinanceTag.fromJson(item)).toList();
  }
}

class StatisticsData {
  const StatisticsData(this.finances, this.tags);
  final List<List<String>> finances;
  final List<TagStatistic> tags;
}

class TagStatistic {
  const TagStatistic(this.name, this.icon, this.income, this.pay);
  final String name;
  final String? icon;
  final double pay;
  final double income;

  factory TagStatistic.fromJson(Map<String, dynamic> json) {
    return TagStatistic(
        json['name'],
        json['icon'],
        double.parse(json['income'].toString()),
        double.parse(json['pay'].toString()));
  }
}
