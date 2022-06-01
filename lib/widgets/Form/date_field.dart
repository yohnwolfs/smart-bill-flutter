import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'input_dropdown.dart';

class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    Key? key,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
    DateTime? initialValue,
    AutovalidateMode? autovalidateMode,
    bool enabled = true,
    InputDecoration? decoration,
    ValueChanged<DateTime>? onDateSelected,
    DateFormat? dateFormat,
    required String labelText,
    Widget? prefix,
  }) : super(
            key: key,
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            autovalidateMode: autovalidateMode,
            enabled: enabled,
            builder: (FormFieldState<DateTime> field) {
              // Theme defaults are applied inside the _InputDropdown widget
              final InputDecoration _decorationWithThemeDefaults =
                  decoration ?? const InputDecoration();

              final InputDecoration effectiveDecoration =
                  _decorationWithThemeDefaults.copyWith(
                      errorText: field.errorText);

              void onChangedHandler(DateTime value) {
                if (onDateSelected != null) {
                  onDateSelected(value);
                }
                field.didChange(value);
              }

              return DateTimeField(
                labelText: labelText,
                prefix: prefix,
                selectedDate: field.value,
                decoration: decoration,
                dateFormat: dateFormat,
                onDateSelected: onChangedHandler,
              );
            });
  @override
  _DateFormFieldState createState() => _DateFormFieldState();
}

class _DateFormFieldState extends FormFieldState<DateTime> {}

class DateTimeField extends StatelessWidget {
  const DateTimeField(
      {required this.selectedDate,
      required this.onDateSelected,
      this.decoration,
      this.dateFormat,
      this.height,
      this.noBorder = false,
      required this.labelText,
      this.prefix,
      Key? key})
      : super(key: key);

  final DateTime? selectedDate;

  final InputDecoration? decoration;

  final DateFormat? dateFormat;

  final ValueChanged<DateTime>? onDateSelected;

  final String labelText;

  final Widget? prefix;

  final double? height;

  final bool noBorder;

  @override
  Widget build(BuildContext context) {
    String? text;

    if (selectedDate != null)
      text = DateFormat('yyyy年-MM月-dd日').format(selectedDate!);

    return Container(
        height: height ?? 60,
        decoration: BoxDecoration(
            color: Colors.white,
            border: noBorder
                ? null
                : Border(
                    bottom: BorderSide(width: 1, color: Colors.grey[200]!))),
        child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                prefix == null
                    ? Container()
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: prefix),
                Text(labelText, style: TextStyle(fontSize: 16))
              ]),
              Padding(padding: EdgeInsets.only(right: 20)),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            locale: DateTimePickerLocale.zh_cn,
                            initialDateTime: selectedDate,
                            pickerMode: DateTimePickerMode.datetime,
                            dateFormat: 'yyyy年-MM月-dd日', onConfirm: (d, l) {
                          if (onDateSelected != null) onDateSelected!(d);
                        });
                      },
                      child: Text(
                        text ?? '',
                        textAlign: TextAlign.right,
                      )))
            ]));
  }
}
