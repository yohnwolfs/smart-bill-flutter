import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleTextField extends StatelessWidget {
  const SimpleTextField(
      {required this.labelText,
      this.contentPadding,
      this.noBorder = false,
      this.height,
      this.initialValue,
      this.decoration,
      this.validator,
      this.prefix,
      this.onSaved,
      this.keyboardType,
      this.inputFormatters,
      this.textAlign,
      Key? key})
      : super(key: key);

  final String labelText;

  final double? height;

  final bool noBorder;

  final String? initialValue;

  final Widget? prefix;

  final EdgeInsetsGeometry? contentPadding;

  final List<TextInputFormatter>? inputFormatters;

  final InputDecoration? decoration;

  final String? Function(String?)? validator;

  final void Function(String?)? onSaved;

  final TextInputType? keyboardType;

  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? 60,
        decoration: BoxDecoration(
            color: Colors.white,
            border: noBorder
                ? null
                : Border(
                    bottom: BorderSide(width: 1, color: Colors.grey[200]!))),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Flexible(
                  child: TextFormField(
                      style: TextStyle(fontSize: 16),
                      initialValue: initialValue,
                      onSaved: onSaved,
                      textAlign: textAlign ?? TextAlign.right,
                      // textDirection: TextDirection.rtl,
                      validator: validator,
                      keyboardType: keyboardType,
                      inputFormatters: inputFormatters,
                      decoration: decoration ??
                          InputDecoration(
                            border: InputBorder.none,
                          )))
            ]));
  }
}
