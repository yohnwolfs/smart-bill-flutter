import 'package:account_book/models/key_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectFormField extends FormField<String> {
  SelectFormField(
      {Key? key,
      FormFieldSetter<String>? onSaved,
      FormFieldValidator<String>? validator,
      String? initialValue,
      AutovalidateMode? autovalidateMode,
      bool enabled = true,
      InputDecoration? decoration,
      ValueChanged<String>? onSelectChanged,
      List<KeyValue>? optionList,
      Widget? prefix,
      required String labelText})
      : super(
            key: key,
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            autovalidateMode: autovalidateMode,
            enabled: enabled,
            builder: (FormFieldState<String> field) {
              void onChangedHandler(String value) {
                if (onSelectChanged != null) {
                  onSelectChanged(value);
                }
                field.didChange(value);
              }

              return SelectField(
                selectedValue: field.value,
                decoration: decoration,
                onSelected: onChangedHandler,
                optionList: optionList,
                labelText: labelText,
                prefix: prefix,
              );
            });

  @override
  _SelectFormFieldState createState() => _SelectFormFieldState();
}

class _SelectFormFieldState extends FormFieldState<String> {}

class SelectField extends StatelessWidget {
  const SelectField({
    required this.selectedValue,
    required this.onSelected,
    required this.labelText,
    this.prefix,
    this.decoration,
    this.optionList,
    this.height,
    this.noBorder = false,
    Key? key,
  }) : super(key: key);

  final String? selectedValue;

  final InputDecoration? decoration;

  final ValueChanged<String>? onSelected;

  final List<KeyValue>? optionList;

  final double? height;

  final bool noBorder;

  final Widget? prefix;

  final String labelText;

  @override
  Widget build(BuildContext context) {
    String? text;
    int index = 0;
    List<KeyValue> ol = optionList ?? [];

    if (selectedValue != null) {
      text = optionList?.firstWhere((e) => e.key == selectedValue).value ?? '';

      for (var i = 0; i < (ol.length); i++) {
        if (ol[i].key == selectedValue) index = i;
      }
    }

    return Container(
      height: height ?? 60,
      decoration: BoxDecoration(
          color: Colors.white,
          border: noBorder
              ? null
              : Border(bottom: BorderSide(width: 1, color: Colors.grey[200]!))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(children: [
          prefix == null
              ? Container()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 6), child: prefix),
          Text(labelText, style: TextStyle(fontSize: 16))
        ]),
        Padding(padding: EdgeInsets.only(right: 20)),
        Expanded(
            child: GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      semanticsDismissible: true,
                      builder: (context) {
                        return Container(
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
                                scrollController: FixedExtentScrollController(
                                    initialItem: index)));
                      });
                },
                child: Text(
                  text ?? '',
                  textAlign: TextAlign.right,
                ))),
        Padding(padding: EdgeInsets.only(right: 4))
      ]),
    );
  }
}
