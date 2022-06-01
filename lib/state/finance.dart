import 'dart:async';

import 'package:account_book/dao/finance_dao.dart';
import 'package:account_book/models/finance.dart';
import 'package:account_book/models/list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FinanceState extends ChangeNotifier {
  ListModel<Finance>? financeListModel;

  String incomeTotalStr = '0';

  String payTotalStr = '0';

  String thisMonthTotalIncome = '0';

  String thisMonthTotalPay = '0';

  int? lastSearchYear;

  int? lastSearchMonth;

  // ignore: cancel_subscriptions
  late StreamSubscription<ListModel<Finance>> subscription;
  //创建StreamController
  // ignore: close_sinks
  late StreamController<ListModel<Finance>> streamController;
  // 获取StreamSink用于发射事件
  StreamSink<ListModel<Finance>> get streamSink => streamController.sink;
  // 获取Stream用于监听
  Stream<ListModel<Finance>> get streamData => streamController.stream;

  void initStream() {
    streamController = StreamController<ListModel<Finance>>();
  }

  void closeStream() {
    subscription.cancel();
    streamController.close();
  }

  void reloadFinances([int? year, int? month]) {
    fetchFinancesByMonth(year ?? lastSearchYear, month ?? lastSearchMonth);
  }

  Future fetchFinances() async {
    List<FinanceTag> res = await FinanceDao().getFinanceTags();

    notifyListeners();
    return res;
  }

  Future<ListModel<Finance>> fetchFinancesByMonth(
      [int? year, int? month]) async {
    late ListModel<Finance> res;
    DateTime today = DateTime.now();

    try {
      res = await FinanceDao().getFinances({
        'month': DateTime(year ?? lastSearchYear ?? today.year,
            month ?? lastSearchMonth ?? today.month)
      });
    } on DioError catch (e) {
      streamSink.addError(e);
    }

    financeListModel = res;

    incomeTotalStr = res.list
        .fold<double>(
            0,
            (value, element) =>
                value + (element.tradingType == 'income' ? element.amount : 0))
        .toStringAsFixed(2);
    payTotalStr = res.list
        .fold<double>(
            0,
            (value, element) =>
                value + (element.tradingType == 'pay' ? element.amount : 0))
        .toStringAsFixed(2);

    lastSearchMonth = month ?? lastSearchMonth ?? today.month;
    lastSearchYear = year ?? lastSearchYear ?? today.year;

    if (today.year == lastSearchYear && today.month == lastSearchMonth) {
      thisMonthTotalIncome = incomeTotalStr;
      thisMonthTotalPay = payTotalStr;
    }

    notifyListeners();

    streamSink.add(res);

    return res;
  }
}
