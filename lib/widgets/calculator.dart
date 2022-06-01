import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';

final Color borderColor = Colors.grey[350]!;
final Color backColor = Colors.grey[200]!;
final double cellHeight = 50;

class Calculator extends StatefulWidget {
  Calculator({this.onSubmit, Key? key}) : super(key: key);

  final void Function(double n, DateTime date, String? desc)? onSubmit;
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String expression = '0';

  DateTime date = DateTime.now();

  String? desc;

  void onDescChanged(String d) {
    setState(() {
      desc = d;
    });
  }

  void onNumTap(String n) {
    if (expression.length > 25) return;
    setState(() {
      if (expression == '0')
        expression = n;
      else
        expression = expression + n;
    });
  }

  void onPointTap() {
    if (canAddPoint(expression) == false) return;
    setState(() {
      expression = expression + '.';
    });
  }

  void onOperatorTap(String op) {
    if (canCalculate(expression)) {
      setState(() {
        calculate();
        expression = expression + op;
      });
      return;
    }
    if (canAddOperator(expression)) {
      setState(() {
        if (expression == '0' && op != '+') {
          expression = op;
          return;
        }
        expression = expression + op;
      });
    }
  }

  void onDateSelectorTap() {
    DatePicker.showDatePicker(context,
        locale: DateTimePickerLocale.zh_cn,
        initialDateTime: date,
        pickerMode: DateTimePickerMode.datetime,
        dateFormat: 'yyyy年-MM月-dd日', onConfirm: (datetime, list) {
      setState(() {
        date = datetime;
      });
    });
  }

  void onDeleteTap() {
    setState(() {
      if (expression.length <= 1) {
        expression = '0';
        return;
      }
      expression = expression.substring(0, expression.length - 1);
    });
  }

  void onCompleteTap() {
    setState(() {
      if (canCalculate(expression)) {
        calculate();
      } else {
        double n = double.parse(expression.replaceAll(RegExp(r"[+|-]"), ''));
        if (widget.onSubmit != null) widget.onSubmit!(n, date, desc);
      }
    });
  }

  void calculate() {
    double? res;
    if (expression.contains('+')) {
      var splitArr = expression.split('+');
      res = double.parse(splitArr[0]) + double.parse(splitArr[1]);
    } else if (expression.contains('-')) {
      var splitArr = expression.split('-');
      res = double.parse(splitArr[0]) - double.parse(splitArr[1]);
    }
    expression = res == null ? expression : res.toString();
  }

  @override
  Widget build(BuildContext context) {
    bool canExpressionCalculate = canCalculate(expression);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: backColor,
            border: Border(top: BorderSide(width: 1, color: borderColor))),
        child: Column(
          children: [
            Container(
                height: cellHeight,
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('描述：', style: TextStyle(fontSize: 16)),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: TextField(
                              onChanged: onDescChanged,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '点击填写账单描述'),
                            ))),
                    Text(expression, style: TextStyle(fontSize: 24))
                    // TextField(decoration: InputDecoration(labelText: "交易商品"))
                  ],
                )),
            Container(
                height: 260,
                decoration: BoxDecoration(
                    color: borderColor,
                    border:
                        Border(top: BorderSide(width: 1, color: borderColor))),
                child: DefaultTextStyle(
                    style: TextStyle(fontSize: 22, color: Colors.black),
                    child: GridView.count(
                      crossAxisCount: 4,
                      childAspectRatio: 5 / 3,
                      shrinkWrap: true,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      physics: new NeverScrollableScrollPhysics(),
                      children: [
                        GridWrapper(
                            child: Text('7'), onTap: () => onNumTap('7')),
                        GridWrapper(
                            child: Text('8'), onTap: () => onNumTap('8')),
                        GridWrapper(
                            child: Text('9'), onTap: () => onNumTap('9')),
                        GridWrapper(
                            child: Text(DateFormat('yyyy/MM/dd').format(date),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            onTap: () => onDateSelectorTap()),
                        GridWrapper(
                            child: Text('4'), onTap: () => onNumTap('4')),
                        GridWrapper(
                            child: Text('5'), onTap: () => onNumTap('5')),
                        GridWrapper(
                            child: Text('6'), onTap: () => onNumTap('6')),
                        GridWrapper(
                            child: Text('+'), onTap: () => onOperatorTap('+')),
                        GridWrapper(
                            child: Text('1'), onTap: () => onNumTap('1')),
                        GridWrapper(
                            child: Text('2'), onTap: () => onNumTap('2')),
                        GridWrapper(
                            child: Text('3'), onTap: () => onNumTap('3')),
                        GridWrapper(
                            child: Text('-'), onTap: () => onOperatorTap('-')),
                        GridWrapper(
                            child: Text('.'), onTap: () => onPointTap()),
                        GridWrapper(
                            child: Text('0'), onTap: () => onNumTap('0')),
                        GridWrapper(
                            child: Icon(Icons.backspace), onTap: onDeleteTap),
                        GridWrapper(
                            child: Text(canExpressionCalculate ? '=' : '完成'),
                            decoration:
                                BoxDecoration(color: Colors.yellow[600]),
                            onTap: () => onCompleteTap()),
                      ],
                    ))),
            // Padding(
            //   padding: EdgeInsets.only(bottom: 20),
            // )
          ],
        ));
  }
}

class GridWrapper extends StatelessWidget {
  const GridWrapper(
      {required this.child, this.decoration, this.onTap, Key? key})
      : super(key: key);

  final Widget child;

  final Decoration? decoration;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: decoration ?? BoxDecoration(color: backColor),
            child: Center(
              child: child,
            )));
  }
}

bool canAddPoint(String str) {
  final lastLetter = str[str.length - 1];
  bool hasOnePoint = str.split('.').length == 2;
  bool hasTwoPoint = str.split('.').length >= 3;
  bool isOperating = isExpOperating(str);

  if (lastLetter == '+' ||
      lastLetter == '-' ||
      lastLetter == '.' ||
      hasTwoPoint ||
      (hasOnePoint && !isOperating)) return false;

  return true;
}

bool canAddOperator(String str) {
  RegExp reg = new RegExp(r"^-?[0-9]+(\.[0-9]+)?$");

  return reg.hasMatch(str);
}

bool isExpOperating(String str) {
  var _str = (str[0] == '-') ? str.substring(1) : str;
  bool hasOperator = _str.contains('+') || _str.contains('-');

  if (hasOperator) return true;

  return false;
}

bool canCalculate(String str) {
  RegExp reg = new RegExp(r"^-?[0-9]+(\.[0-9]+)?[+|-][0-9]+(\.[0-9]+)?$");
  return reg.hasMatch(str);
}
