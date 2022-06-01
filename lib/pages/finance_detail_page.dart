import 'package:account_book/dao/finance_dao.dart';
import 'package:account_book/models/finance.dart';
import 'package:account_book/models/key_value.dart';
import 'package:account_book/navigator/navigation_util.dart';
import 'package:account_book/state/finance.dart';
import 'package:account_book/state/finance_book.dart';
import 'package:account_book/widgets/Form/date_field.dart';
import 'package:account_book/widgets/Form/select_field.dart';
import 'package:account_book/widgets/Form/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FinanceDetailPage extends StatefulWidget {
  FinanceDetailPage({Key? key}) : super(key: key);

  @override
  _FinanceDetailPageState createState() => _FinanceDetailPageState();
}

class _FinanceDetailPageState extends State<FinanceDetailPage> {
  Finance? data;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Finance? d = ModalRoute.of(context)?.settings.arguments as dynamic;

    setState(() {
      data = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            shadowColor: Theme.of(context).shadowColor,
            centerTitle: true,
            title: Text('账单详情')),
        body: Column(children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: data != null
                          ? DetailPanel(data!, onSave: (data) {
                              Provider.of<FinanceState>(context, listen: false)
                                  .reloadFinances();
                            })
                          : Container())))
        ]));
  }
}

class DetailPanel extends StatefulWidget {
  DetailPanel(this.data, {required this.onSave, Key? key}) : super(key: key);

  final Finance data;

  final void Function(Map<String, dynamic> data) onSave;

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<DetailPanel> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late List<FinanceBook> books;

  Map<String, dynamic> formValues = {};

  @override
  initState() {
    super.initState();
    books = Provider.of<FinanceBookState>(context, listen: false).books ?? [];
  }

  void onSave(Map<String, dynamic> formValues) async {
    _formKey.currentState?.save();
    if (widget.data.id != null) {
      // try {
      Map<String, dynamic> params = widget.data.toJson();
      params.addAll(formValues);
      Map<String, dynamic> transform = {
        'goods': params['goods'],
        'tradingTime': int.parse(params['tradingTime']),
        'amount': params['amount'],
        'bookId': params['bookId'],
        'tradingType': params['tradingType'],
        'tradingParty': params['tradingParty'],
        'tradingOrder': params['tradingOrder'],
        'paymentType': params['paymentType'],
        'merchantOrder': params['merchantOrder'],
        'remark': params['remark'],
        'userId': params['userId'],
        'tags': params['tags'] != null
            ? params['tags'].map((item) => item.toJson()['id']).toList()
            : []
      };
      await FinanceDao().updateFinance(widget.data.id!, transform);
      NavigationUtil.getInstance().pop();

      widget.onSave(transform);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: Colors.white),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                // 触摸收起键盘
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(children: [
                SimpleTextField(
                    labelText: '交易商品',
                    prefix: Icon(Icons.anchor),
                    initialValue: widget.data.goods,
                    onSaved: (value) => formValues['goods'] = value,
                    validator: (v) {
                      return v == null || v.trim().length > 0
                          ? null
                          : "交易商品不能为空";
                    }),
                SimpleTextField(
                    labelText: '交易金额',
                    initialValue: widget.data.amount.toString(),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter(RegExp("[0-9.]"), allow: true)
                    ],
                    prefix: Icon(Icons.money),
                    onSaved: (value) =>
                        formValues['amount'] = double.parse(value ?? '0'),
                    validator: (v) {
                      return v == null || v.trim().length > 0
                          ? null
                          : "交易金额不能为空";
                    }),
                SelectFormField(
                    labelText: '账本',
                    initialValue: widget.data.bookId,
                    prefix: Icon(Icons.book),
                    onSaved: (value) => formValues['bookId'] = value,
                    optionList: books
                        .map((item) => KeyValue(item.id ?? '', item.name))
                        .toList(),
                    validator: (v) {
                      return v == null || v.trim().length > 0 ? null : "账本不能为空";
                    }),
                SelectFormField(
                    labelText: '交易类型',
                    initialValue: widget.data.tradingType,
                    prefix: Icon(Icons.sync_alt),
                    onSaved: (value) => formValues['tradingType'] = value,
                    optionList: [
                      KeyValue('pay', '支出'),
                      KeyValue('income', '收入')
                    ],
                    validator: (v) {
                      return v == null || v.trim().length > 0
                          ? null
                          : "交易类型不能为空";
                    }),
                SimpleTextField(
                  labelText: '交易方',
                  prefix: Icon(Icons.account_circle),
                  initialValue: widget.data.tradingParty,
                  onSaved: (value) => formValues['tradingParty'] = value,
                ),
                DateTimeFormField(
                  labelText: '交易时间',
                  prefix: Icon(Icons.calendar_today),
                  initialValue: DateTime.fromMillisecondsSinceEpoch(
                      int.parse(widget.data.tradingTime ?? '')),
                  onSaved: (value) => formValues['tradingTime'] =
                      value?.millisecondsSinceEpoch.toString(),
                ),
                SelectFormField(
                  labelText: '支付类型',
                  initialValue: widget.data.paymentType,
                  prefix: Icon(Icons.payment),
                  optionList: [
                    KeyValue('alipay', '支付宝'),
                    KeyValue('wechat', '微信'),
                    KeyValue('other', '其他'),
                  ],
                  onSaved: (value) => formValues['paymentType'] = value,
                ),
                SimpleTextField(
                  labelText: "交易单号",
                  prefix: Icon(Icons.request_page),
                  initialValue: widget.data.tradingOrder,
                  onSaved: (value) => formValues['tradingOrder'] = value,
                ),
                SimpleTextField(
                  labelText: "备注",
                  prefix: Icon(Icons.wysiwyg),
                  initialValue: widget.data.remark,
                  onSaved: (value) => formValues['remark'] = value,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 320,
                        child: ElevatedButton(
                            onPressed: () {
                              onSave(formValues);
                            },
                            child: Text('保存', style: TextStyle(fontSize: 18)))),
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                    ),
                    // Container(
                    //     width: 170,
                    //     child: ElevatedButton(
                    //         onPressed: () async {
                    //           Navigator.pop(context);
                    //         },
                    //         style: ButtonStyle(
                    //           backgroundColor: MaterialStateProperty.all<Color>(
                    //               Colors.grey[300]!),
                    //         ),
                    //         child: Text('取消', style: TextStyle(fontSize: 18)))),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                ),
              ])),
        ));
  }
}
