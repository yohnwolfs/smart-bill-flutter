import 'package:flutter/material.dart';

class SwitchField extends StatefulWidget {
  SwitchField(
      {this.initialValue,
      required this.labelText,
      this.height,
      this.noBorder = false,
      this.prefix,
      required this.onChanged,
      Key? key})
      : super(key: key);

  final bool? initialValue;

  final String labelText;

  final Widget? prefix;

  final double? height;

  final bool noBorder;

  final void Function(bool) onChanged;

  @override
  _SwitchFieldState createState() => _SwitchFieldState();
}

class _SwitchFieldState extends State<SwitchField> {
  bool value = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      value = widget.initialValue ?? false;
    });
  }

  void onChanged(bool v) {
    setState(() {
      value = v;
    });
    widget.onChanged(v);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height ?? 60,
        decoration: BoxDecoration(
            color: Colors.white,
            border: widget.noBorder
                ? null
                : Border(
                    bottom: BorderSide(width: 1, color: Colors.grey[200]!))),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                widget.prefix == null
                    ? Container()
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: widget.prefix),
                Text(widget.labelText, style: TextStyle(fontSize: 16))
              ]),
              Padding(padding: EdgeInsets.only(right: 20)),
              Flexible(child: Switch(value: value, onChanged: onChanged))
            ]));
  }
}
