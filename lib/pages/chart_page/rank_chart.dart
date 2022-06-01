import 'package:account_book/dao/finance_dao.dart';
import 'package:account_book/widgets/no_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../constants.dart';

class RankChart extends StatefulWidget {
  RankChart({this.tags, Key? key}) : super(key: key);

  final List<TagStatistic>? tags;

  @override
  _RankChartState createState() => _RankChartState();
}

class _RankChartState extends State<RankChart> {
  String type = 'pay';

  @override
  Widget build(BuildContext context) {
    final incomeTags =
        widget.tags?.where((item) => item.income > 0).toList() ?? [];
    final payTags = widget.tags?.where((item) => item.pay > 0).toList() ?? [];
    final incomeTotal = incomeTags.fold<double>(0, (value, element) {
      return value + element.income;
    });
    final payTotal = payTags.fold<double>(0, (value, element) {
      return value + element.pay;
    });

    payTags.sort((a, b) {
      if (a.pay > b.pay)
        return -1;
      else
        return 1;
    });
    incomeTags.sort((a, b) {
      if (a.income > b.income)
        return -1;
      else
        return 1;
    });

    return DefaultTabController(
        length: 2,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            // decoration: BoxDecoration(
            //     border: Border(top: BorderSide(color: Colors.blueGrey[100]!))),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.only(bottom: 12),
                        child: TabBar(
                            unselectedLabelColor: Colors.grey[400],
                            indicator: UnderlineTabIndicator(
                                insets: EdgeInsets.fromLTRB(62, -4, 62, -4),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2)),
                            tabs: [
                              Tab(
                                  child: Text('支出排行榜',
                                      style: TextStyle(fontSize: 16))),
                              Tab(
                                  child: Text('收入排行榜',
                                      style: TextStyle(fontSize: 16)))
                            ],
                            onTap: (index) {
                              setState(() {
                                type = index == 0 ? 'pay' : 'income';
                              });
                            })),
                    Center(
                        // width: 300,
                        child: widget.tags == null
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 60),
                                child: SpinKitThreeBounce(
                                  color: Theme.of(context).primaryColor,
                                  size: 50.0,
                                ))
                            : ((type == 'pay' && payTags.length == 0) ||
                                    (type == 'income' &&
                                        incomeTags.length == 0))
                                ? NoContent()
                                : Container()),
                    ...(type == 'pay'
                        ? payTags
                            .map((item) => RankRow(
                                  name: item.name,
                                  icon: item.icon,
                                  amount: item.pay,
                                  percent: (item.pay / payTotal * 100)
                                      .toStringAsFixed(2),
                                ))
                            .toList()
                        : incomeTags
                            .map((item) => RankRow(
                                  name: item.name,
                                  icon: item.icon,
                                  amount: item.income,
                                  percent: (item.income / incomeTotal * 100)
                                      .toStringAsFixed(2),
                                ))
                            .toList())
                  ],
                ))
              ],
            )));
  }
}

class RankRow extends StatelessWidget {
  const RankRow(
      {this.name = '',
      this.icon,
      this.percent = '0',
      this.amount = 0,
      Key? key})
      : super(key: key);

  final String name;

  final String percent;

  final double amount;

  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        children: [
          CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.all(4),
                  child: icon != null
                      ? Image.network(Config().server + icon!)
                      : Text('?',
                          style: TextStyle(fontSize: 22, color: Colors.black))),
              backgroundColor: Colors.grey[300]),
          Padding(padding: EdgeInsets.only(right: 12)),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('$name $percent%'), Text('$amount')]),
              Padding(padding: EdgeInsets.only(bottom: 4)),
              Progress(
                  width: double.infinity,
                  value: double.parse(percent) <= 0
                      ? 0
                      : (double.parse(percent) / 100))
            ],
          )),
        ],
      ),
    );
  }
}

class Progress extends StatelessWidget {
  const Progress(
      {this.value = 1,
      this.width = 120,
      this.height = 12,
      this.bgColor,
      this.frColor,
      Key? key})
      : super(key: key);

  final double value;
  final double width;
  final double height;
  final Color? bgColor;
  final Color? frColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(height)),
                  color: bgColor ?? Colors.blueGrey[100]),
            ),
            Container(
              width: value * (MediaQuery.of(context).size.width - 70),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(height)),
                  color: frColor ?? Colors.black),
            ),
          ],
        ));
  }
}
