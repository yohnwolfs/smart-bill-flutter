import 'package:account_book/dao/finance_dao.dart';
import 'package:account_book/models/finance.dart';
import 'package:account_book/models/key_value.dart';
import 'package:account_book/navigator/navigation_util.dart';
import 'package:account_book/widgets/Form/image_field.dart';
import 'package:account_book/widgets/Form/select_field.dart';
import 'package:account_book/widgets/Form/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class TagDetailPage extends StatefulWidget {
  TagDetailPage({Key? key}) : super(key: key);

  @override
  _TagDetailPageState createState() => _TagDetailPageState();
}

class _TagDetailPageState extends State<TagDetailPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? tagName;

  FinanceTag? data;

  String? type;

  String? tagType;

  String? order;

  PickedFile? icon;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as dynamic;

    setState(() {
      data = arguments['data'];
      type = arguments['type'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            shadowColor: Theme.of(context).shadowColor,
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: () async {
                  _formKey.currentState?.save();
                  if (type == 'add') {
                    await FinanceDao().addFinanceTag({
                      'name': tagName,
                      'type': tagType,
                      'order': order == null ? null : int.parse(order!),
                      'icon': icon
                    });

                    NavigationUtil.getInstance().pop(true);
                  } else {
                    if (data?.id != null)
                      await FinanceDao().updateFinanceTag(data!.id!, {
                        'name': tagName,
                        'type': tagType,
                        'order': order == null ? null : int.parse(order!),
                        'icon': icon
                      });

                    NavigationUtil.getInstance().pop(true);
                  }
                },
                child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Center(
                        child: Text(type == 'add' ? '发送' : '保存',
                            style: TextStyle(fontSize: 20)))),
              )
            ],
            title: Text(type == 'add' ? '创建标签' : '标签详情')),
        body: Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Card(
                child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(children: [
                      ImageFormField(
                        initialValue: data?.icon,
                        labelText: '图标',
                        onSelectChanged: (path, file) {
                          icon = file;
                        },
                      ),
                      SimpleTextField(
                          initialValue: data?.name,
                          labelText: '标签名称',
                          onSaved: (str) {
                            tagName = str;
                          },
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 20, 0)),
                      SelectFormField(
                          labelText: '类型',
                          initialValue: data?.type ?? 'pay',
                          onSaved: (value) => tagType = value,
                          optionList: [
                            {'key': 'pay', 'value': '支出'},
                            {'key': 'income', 'value': '收入'}
                          ]
                              .map((item) =>
                                  KeyValue(item['key'] ?? '', item['value']))
                              .toList(),
                          validator: (v) {
                            return v == null || v.trim().length > 0
                                ? null
                                : "类型不能为空";
                          }),
                      SimpleTextField(
                        labelText: '排序',
                        initialValue: data?.order.toString() ?? '0',
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp("[0-9.]"),
                              allow: true)
                        ],
                        onSaved: (value) => order = value,
                      ),
                    ])))));
  }
}
