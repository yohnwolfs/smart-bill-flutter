import 'dart:async';

import 'package:account_book/dao/finance_dao.dart';
import 'package:account_book/models/finance.dart';
import 'package:account_book/models/list.dart';
import 'package:account_book/navigator/navigation_util.dart';
import 'package:account_book/pages/home_page/finance_list_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BookFinanceList extends StatefulWidget {
  BookFinanceList({Key? key}) : super(key: key);

  @override
  _BookFinanceListState createState() => _BookFinanceListState();
}

class _BookFinanceListState extends State<BookFinanceList> {
  String? bookId;

  late int selectedMonth;
  late int selectedYear;

  ListModel<Finance>? financeListModel;

  late StreamController<ListModel<Finance>> streamController;

  StreamSink<ListModel<Finance>> get streamSink => streamController.sink;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now().month;
    selectedYear = DateTime.now().year;

    streamController = StreamController<ListModel<Finance>>();
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bookId = ModalRoute.of(context)?.settings.arguments as dynamic;

    fetchFinancesByMonth(bookId);
  }

  void reloadFinances() {
    fetchFinancesByMonth(bookId);
  }

  Future<ListModel<Finance>> fetchFinancesByMonth(bookId,
      [int? year, int? month]) async {
    late ListModel<Finance> res;

    res = await FinanceDao().getFinances({
      'bookId': bookId,
      // 'month': DateTime(year ?? selectedYear, month ?? selectedMonth)
    });

    financeListModel = res;

    if (year != null) selectedYear = year;
    if (month != null) selectedMonth = month;

    streamSink.add(res);

    return res;
  }

  void onListItemAction(Finance data, FinanceListItemAction action) async {
    switch (action) {
      case FinanceListItemAction.delete:
        {
          if (data.id != null) {
            await FinanceDao().deleteFinance([data.id!]);
            reloadFinances();
          }
          break;
        }
      case FinanceListItemAction.detail:
        {
          NavigationUtil.getInstance()
              .pushNamed('finance_detail', arguments: data);
          break;
        }
      case FinanceListItemAction.changeTag:
        {
          reloadFinances();
          break;
        }
      default:
        {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            shadowColor: Theme.of(context).shadowColor,
            centerTitle: true,
            actions: [Padding(padding: EdgeInsets.only(right: 46))],
            title: Text('账单')
            // title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //   GestureDetector(
            //       onTap: () {
            //         DatePicker.showDatePicker(context,
            //             locale: DateTimePickerLocale.zh_cn,
            //             initialDateTime: DateTime(selectedYear, selectedMonth),
            //             pickerMode: DateTimePickerMode.datetime,
            //             dateFormat: 'yyyy年-MM月', onConfirm: (datetime, list) {
            //           setState(() {
            //             selectedMonth = datetime.month;
            //             selectedYear = datetime.year;
            //             fetchFinancesByMonth(
            //                 bookId, selectedYear, selectedMonth);
            //           });
            //         });
            //       },
            //       child: DropdownSelector(
            //           child: Text.rich(TextSpan(children: [
            //         TextSpan(
            //             text: '$selectedYear-${toMonth(selectedMonth)}',
            //             style: TextStyle(
            //               fontSize: 24,
            //             )),
            //         // TextSpan(text: '', style: TextStyle(fontSize: 16))
            //       ]))))
            // ])
            ),
        body: Column(children: [
          StreamBuilder<ListModel<Finance>>(
              stream: streamController.stream,
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting)
                  return Expanded(
                      child: Center(
                    child: SpinKitThreeBounce(
                      color: Theme.of(context).primaryColor,
                      size: 50.0,
                    ),
                  ));
                else if (snapShot.hasError) {
                  bool isNetworkError =
                      (snapShot.error as dynamic)!.type == DioErrorType.other;
                  return Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                          isNetworkError
                              ? 'images/network_error.png'
                              : 'images/error.png',
                          width: 160),
                      Padding(padding: EdgeInsets.only(bottom: 8)),
                      Text(isNetworkError ? '网络未连接' : '服务器错误',
                          style:
                              TextStyle(fontSize: 18, color: Colors.black54)),
                    ],
                  ));
                } else {
                  return FinanceListView(
                    data: snapShot.data!,
                    onListItemAction: onListItemAction,
                    disablePullBehavior: true,
                  );
                }
              })
        ]));
  }
}

String toMonth(int month) {
  int l = month.toString().length;
  return l > 1 ? month.toString() : '0$month';
}
