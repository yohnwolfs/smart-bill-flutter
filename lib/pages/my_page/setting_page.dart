import 'package:account_book/navigator/navigation_util.dart';
import 'package:account_book/pages/my_page/functional_module_container.dart';
import 'package:account_book/state/finance.dart';
import 'package:account_book/state/finance_book.dart';
import 'package:account_book/state/finance_statistics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

import '../../constants.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String serverUrl = Config().server;

  @override
  void initState() {
    super.initState();
  }

  void onSave() {
    SpUtil.putString('serverUrl', serverUrl);
    Fluttertoast.showToast(msg: '保存成功', gravity: ToastGravity.CENTER);

    Provider.of<FinanceState>(context, listen: false).fetchFinancesByMonth();
    Provider.of<FinanceBookState>(context, listen: false).fetchFinanceBooks();
    Provider.of<FinanceStatisticsState>(context, listen: false)
        .fetchStatistics();

    NavigationUtil.getInstance().pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Theme.of(context).shadowColor,
          title: Text('设置'),
          actions: [
            TextButton(
              child: Text('保存',
                  style: TextStyle(color: Colors.black, fontSize: 18)),
              onPressed: onSave,
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Column(children: [
              FunctionalModuleContainer(
                title: Text('服务器地址'),
                content: TextFormField(
                  initialValue: serverUrl,
                  onChanged: (v) {
                    serverUrl = v;
                  },
                  decoration: InputDecoration(
                    hintText: '请填写',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ])));
  }
}
