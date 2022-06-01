import 'package:account_book/dao/finance_dao.dart';
import 'package:flutter/material.dart';

class FinanceStatisticsState extends ChangeNotifier {
  StatisticsData? statisticData;

  int? lastStartStamp;

  int? lastEndStamp;

  Future fetchStatistics([int? startStamp, int? endStamp]) async {
    StatisticsData res = await FinanceDao().getFinanceStatistics(
      startStamp ?? lastStartStamp ?? 0,
      endStamp ?? lastEndStamp ?? 0,
    );

    statisticData = res;

    lastStartStamp = startStamp;
    lastEndStamp = endStamp;

    notifyListeners();
  }
}
