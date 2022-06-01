import 'package:account_book/navigator/navigation_util.dart';
import 'package:account_book/widgets/Form/simple_text_field.dart';
import 'package:flutter/material.dart';

class FinanceBookCreatorPage extends StatefulWidget {
  FinanceBookCreatorPage({Key? key}) : super(key: key);

  @override
  _FinanceBookCreatorPageState createState() => _FinanceBookCreatorPageState();
}

class _FinanceBookCreatorPageState extends State<FinanceBookCreatorPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? bookName;

  void onSave() {
    _formKey.currentState?.save();

    NavigationUtil.getInstance().pop({'name': bookName});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            shadowColor: Theme.of(context).shadowColor,
            centerTitle: true,
            actions: [Padding(padding: EdgeInsets.only(right: 46))],
            title: Text('新建账本')
            // automaticallyImplyLeading: false,
            ),
        body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(children: [
              Container(
                  margin: EdgeInsets.fromLTRB(0, 12, 0, 24),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom:
                              BorderSide(width: 1, color: Colors.grey[200]!),
                          top: BorderSide(width: 1, color: Colors.grey[200]!))),
                  child: SimpleTextField(
                      labelText: '账本名称',
                      noBorder: true,
                      onSaved: (str) {
                        bookName = str;
                      })),
              ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 46),
                  child: ElevatedButton(
                      onPressed: onSave,
                      child: Text('保存', style: TextStyle(fontSize: 18))))
            ])));
  }
}
