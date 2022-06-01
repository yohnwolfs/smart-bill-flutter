import 'package:account_book/dao/finance_dao.dart';
import 'package:account_book/models/finance.dart';
import 'package:account_book/models/list.dart';
import 'package:account_book/navigator/navigation_util.dart';
import 'package:account_book/pages/home_page/finance_list_view.dart';
import 'package:account_book/state/finance.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'top_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late int selectedMonth;
  late int selectedYear;

  @override
  initState() {
    super.initState();
    selectedMonth = DateTime.now().month;
    selectedYear = DateTime.now().year;

    Provider.of<FinanceState>(context, listen: false).initStream();

    Provider.of<FinanceState>(context, listen: false)
        .fetchFinancesByMonth(selectedYear, selectedMonth);
  }

  @override
  dispose() {
    super.dispose();
  }

  bool get wantKeepAlive => true;

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

  // 刷新列表
  void reloadFinances([int? year, int? month]) {
    Provider.of<FinanceState>(context, listen: false)
        .reloadFinances(year, month);
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Consumer<FinanceState>(builder: (context, financeState, child) {
      return Container(
          alignment: Alignment.topLeft,
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(24, 24, 0, 12),
                  child: TopBar(
                    dateTime: DateTime(selectedYear, selectedMonth),
                    income: financeState.incomeTotalStr,
                    cost: financeState.payTotalStr,
                    onConfirm: (year, month) {
                      selectedYear = year;
                      selectedMonth = month;
                      reloadFinances(year, month);
                    },
                  )),
              StreamBuilder<ListModel<Finance>>(
                  stream: financeState.streamData,
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
                      bool isNetworkError = (snapShot.error as dynamic)!.type ==
                          DioErrorType.other;
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
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54)),
                        ],
                      ));
                    } else {
                      // if (snapShot.hasData && snapShot.data!.list.isNotEmpty)
                      return FinanceListView(
                          data: snapShot.data!,
                          onPullDown: () {
                            final tempMonth = selectedMonth;

                            selectedMonth =
                                tempMonth == 1 ? 12 : (tempMonth - 1);
                            selectedYear = tempMonth == 1
                                ? (selectedYear - 1)
                                : selectedYear;

                            reloadFinances(selectedYear, selectedMonth);
                          },
                          onPullUp: () {
                            final tempMonth = selectedMonth;

                            selectedMonth =
                                tempMonth == 12 ? 1 : (tempMonth + 1);
                            selectedYear = tempMonth == 12
                                ? (selectedYear + 1)
                                : selectedYear;

                            reloadFinances(selectedYear, selectedMonth);
                          },
                          onListItemAction: onListItemAction);
                      // else
                      //   return Expanded(
                      //       child: Center(
                      //     child: NoContent(),
                      //   ));
                    }
                  }),
            ],
          ));
    });
  }
}
