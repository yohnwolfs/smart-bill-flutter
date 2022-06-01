import 'package:account_book/models/finance.dart';
import 'package:account_book/utils/utils.dart';
import 'package:account_book/widgets/Form/simple_text_field.dart';
import 'package:account_book/widgets/Form/switch_field.dart';
import 'package:flutter/material.dart';

class FinanceBookForm extends StatefulWidget {
  FinanceBookForm({required this.data, this.onSave, this.onDelete, Key? key})
      : super(key: key);

  final FinanceBook data;

  final void Function(Map<String, dynamic>)? onSave;

  final void Function(FinanceBook)? onDelete;

  @override
  _FinanceBookFormState createState() => _FinanceBookFormState();
}

class _FinanceBookFormState extends State<FinanceBookForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? bookName;

  bool? isArchive;

  @override
  void initState() {
    super.initState();
    isArchive = widget.data.isArchive ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 260,
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Card(
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: [
                    SimpleTextField(
                        initialValue: widget.data.name,
                        labelText: '账本名称',
                        onSaved: (str) {
                          bookName = str;
                        },
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 20, 0)),
                    SwitchField(
                        initialValue: widget.data.isArchive,
                        labelText: '归档',
                        onChanged: (v) {
                          isArchive = v;
                        }),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 130,
                            child: ElevatedButton(
                                onPressed: () {
                                  _formKey.currentState?.save();
                                  if (widget.onSave != null)
                                    widget.onSave!({
                                      'name': bookName,
                                      'isArchive': isArchive
                                    });
                                },
                                child: Text('保存',
                                    style: TextStyle(fontSize: 18)))),
                        Padding(
                          padding: EdgeInsets.only(right: 12),
                        ),
                        Container(
                            width: 130,
                            child: ElevatedButton(
                                onPressed: () async {
                                  final res = await showConfirmDialog(context);

                                  if (widget.onDelete != null && res == true)
                                    widget.onDelete!(widget.data);
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      // MaterialStateProperty.all<Color>(
                                      //     Colors.transparent)
                                      MaterialStateProperty.all<Color>(
                                          Colors.red[300]!),
                                ),
                                child: Text('删除',
                                    style: TextStyle(fontSize: 18)))),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                  ],
                ))));
  }
}
