import 'package:account_book/dao/finance_dao.dart';
import 'package:account_book/models/finance.dart';
import 'package:account_book/models/list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FinanceBookState extends ChangeNotifier {
  List<FinanceBook>? books;
  List<FinanceBook>? archiveBooks;

  Future fetchFinanceBooks() async {
    ListModel<FinanceBook>? res;
    try {
      res = await FinanceDao().getFinanceBooks();
    } catch (e) {}

    books = res == null
        ? []
        : res.list.where((item) => item.isArchive == false).toList();
    archiveBooks = res == null
        ? []
        : res.list.where((item) => item.isArchive == true).toList();

    notifyListeners();
    return res;
  }

  Future addFinanceBook(Map<String, dynamic> params) async {
    await FinanceDao().addFinanceBook(params);
    await fetchFinanceBooks();

    notifyListeners();
  }

  Future deleteFinanceBook(String id) async {
    await FinanceDao().deleteFinanceBook([id]);
    await fetchFinanceBooks();

    notifyListeners();
  }

  Future updateFinanceBook(String id, Map<String, dynamic> params) async {
    await FinanceDao().updateFinacneBook(id, params);
    await fetchFinanceBooks();

    notifyListeners();
  }

  Future updateFinanceBookBg(String id, FormData data) async {
    await FinanceDao().updateFinanceBookBg(id, data);
    await fetchFinanceBooks();

    notifyListeners();
  }
}
