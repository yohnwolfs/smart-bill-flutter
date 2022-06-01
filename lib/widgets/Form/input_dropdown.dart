import 'package:flutter/material.dart';

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    Key? key,
    required this.text,
    this.decoration,
    this.textStyle,
    this.onPressed,
  }) : super(key: key);

  final String text;

  final InputDecoration? decoration;

  final TextStyle? textStyle;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final InputDecoration effectiveDecoration = decoration ??
        const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
        ).applyDefaults(Theme.of(context).inputDecorationTheme);

    return GestureDetector(
      onTap: onPressed,
      child: InputDecorator(
        decoration: effectiveDecoration,
        child: Text(text, style: textStyle),
      ),
    );
  }
}
