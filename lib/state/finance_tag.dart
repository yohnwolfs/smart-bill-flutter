import 'package:account_book/dao/finance_dao.dart';
import 'package:account_book/models/finance.dart';
import 'package:flutter/material.dart';

class FinanceTagState extends ChangeNotifier {
  List<FinanceTag>? incomeTags;
  List<FinanceTag>? payTags;

  Future fetchFinanceTags() async {
    List<FinanceTag> res = await FinanceDao().getFinanceTags();
    incomeTags = res.where((item) => item.type == 'income').toList();
    payTags = res.where((item) => item.type == 'pay').toList();
    notifyListeners();
    return res;
  }
}
