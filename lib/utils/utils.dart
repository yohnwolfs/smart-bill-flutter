import 'package:flutter/material.dart';

Future<T?> showConfirmDialog<T>(BuildContext context,
    [String? title, String? content]) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("取消"),
    onPressed: () {
      Navigator.pop(context, false);
    },
  );
  Widget continueButton = TextButton(
    child: Text("是的"),
    onPressed: () {
      Navigator.pop(context, true);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title ?? "删除确认"),
    content: Text(content ?? "是否确定要删除该项目?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  return showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
