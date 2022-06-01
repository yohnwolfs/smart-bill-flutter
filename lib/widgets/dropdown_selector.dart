import 'package:account_book/models/key_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownSelector extends StatelessWidget {
  const DropdownSelector(
      {this.child,
      this.value,
      this.onSelected,
      this.mode,
      this.style,
      this.optionList,
      Key? key})
      : super(key: key);

  final Widget? child;

  final String? value;

  final String? mode; // Picker or ActionSheet

  final TextStyle? style;

  final List<KeyValue>? optionList;

  final ValueChanged<String>? onSelected;

  void onDropdownTap(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        semanticsDismissible: true,
        builder: (context) {
          return mode == null || mode == 'Picker'
              ? Container(
                  height: MediaQuery.of(context).size.height / 5,
                  child: CupertinoPicker(
                      itemExtent: 32,
                      backgroundColor: Colors.white,
                      children: optionList != null
                          ? optionList!.map<Widget>((item) {
                              return Text(item.value);
                            }).toList()
                          : [],
                      onSelectedItemChanged: (index) {
                        if (onSelected != null && optionList != null)
                          onSelected!(optionList![index].key);
                      },
                      scrollController:
                          FixedExtentScrollController(initialItem: 0)))
              : Container(
                  // height: MediaQuery.of(context).size.height / 5,
                  child: CupertinoActionSheet(
                      actions: optionList != null
                          ? optionList!.map<Widget>((item) {
                              return CupertinoActionSheetAction(
                                child: Text(item.value,
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () {
                                  if (onSelected != null && optionList != null)
                                    onSelected!(item.key);
                                  Navigator.pop(context);
                                },
                                isDefaultAction: true,
                              );
                            }).toList()
                          : []));
        });
    // })
  }

  @override
  Widget build(BuildContext context) {
    String label = optionList != null
        ? optionList!.firstWhere((item) {
            return item.key == value;
          }).value
        : value ?? '';

    Widget body = Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      child ??
          Container(
              // height: 60,
              child: Text(label, style: style ?? TextStyle(fontSize: 20))),
      Icon(Icons.arrow_drop_down, size: 36)
    ]);

    return optionList != null
        ? GestureDetector(
            onTap: () {
              onDropdownTap(context);
            },
            child: body)
        : body;
  }
}
