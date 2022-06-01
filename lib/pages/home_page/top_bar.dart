// 顶部栏
import 'package:account_book/widgets/dropdown_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

class TopBar extends StatefulWidget {
  TopBar(
      {this.dateTime,
      required this.income,
      required this.cost,
      required this.onConfirm,
      Key? key})
      : super(key: key);

  final DateTime? dateTime;
  final String income;
  final String cost;
  final Function(int year, int month)? onConfirm;

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  // late int selectedMonth;
  // late int selectedYear;

  @override
  Widget build(BuildContext context) {
    final incomeS = widget.income.replaceFirst(RegExp(r'\.00'), '');
    final payS = widget.cost.replaceFirst(RegExp(r'\.00'), '');
    final selectedMonth =
        widget.dateTime != null ? widget.dateTime!.month : DateTime.now().month;
    final selectedYear =
        widget.dateTime != null ? widget.dateTime!.year : DateTime.now().year;

    final incomeFontSize = (180 / incomeS.length).ceilToDouble();
    final payFontSize = (180 / payS.length).ceilToDouble();

    return Container(
      alignment: Alignment.topLeft,
      height: 60,
      // decoration:
      //     BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
      child: Flex(direction: Axis.horizontal, children: [
        StatisticInfoItem(
          desc: '$selectedYear年',
          width: 120,
          onTap: () {
            DatePicker.showDatePicker(context,
                locale: DateTimePickerLocale.zh_cn,
                initialDateTime: DateTime(selectedYear, selectedMonth),
                pickerMode: DateTimePickerMode.datetime,
                dateFormat: 'yyyy年-MM月', onConfirm: (datetime, list) {
              setState(() {
                if (widget.onConfirm != null)
                  widget.onConfirm!(datetime.year, datetime.month);
              });
            });
          },
          child: DropdownSelector(
              child: Text.rich(TextSpan(children: [
            TextSpan(
                text: '${toMonth(selectedMonth)}',
                style: TextStyle(
                  fontSize: 30,
                )),
            TextSpan(text: '月', style: TextStyle(fontSize: 16))
          ]))),
        ),
        Expanded(
            child: Flex(direction: Axis.horizontal, children: [
          StatisticInfoItem(
              data: incomeS,
              fontSize: incomeFontSize > 30 ? 30 : incomeFontSize,
              desc: '收入',
              width: 120),
          StatisticInfoItem(
              data: payS,
              fontSize: payFontSize > 30 ? 30 : payFontSize,
              desc: '支出',
              width: 120)
        ]))
      ]),
    );
  }
}

// 月份转换器
String toMonth(int month) {
  int l = month.toString().length;
  return l > 1 ? month.toString() : '0$month';
}

// statistic布局item
class StatisticInfoItem extends StatelessWidget {
  final Widget? child;
  final String? data;
  final String? desc;
  final double? width;
  final double? fontSize;
  final void Function()? onTap;
  const StatisticInfoItem(
      {this.child,
      this.width,
      this.fontSize,
      this.data,
      this.desc,
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: width,
            height: 60,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Text('$desc', style: TextStyle(color: Colors.black54)),
                Positioned(
                    top: 24,
                    child: Container(
                      height: 40,
                      // decoration: BoxDecoration(
                      //     // color: Theme.of(context).primaryColor,
                      //     borderRadius: BorderRadius.circular(50)),
                      child: data != null
                          ? Align(
                              alignment: Alignment.center,
                              child: Text(data ?? '',
                                  style: TextStyle(
                                    fontSize: fontSize ?? 30,
                                  )))
                          : child,
                    ))
              ],
            )));
  }
}
