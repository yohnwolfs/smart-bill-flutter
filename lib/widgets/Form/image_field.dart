import 'dart:io';

import 'package:account_book/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageFormField extends FormField<String> {
  ImageFormField(
      {Key? key,
      FormFieldSetter<String>? onSaved,
      String? initialValue,
      AutovalidateMode? autovalidateMode,
      bool enabled = true,
      InputDecoration? decoration,
      Function(String, PickedFile)? onSelectChanged,
      Widget? prefix,
      required String labelText})
      : super(
            key: key,
            initialValue: initialValue,
            onSaved: onSaved,
            autovalidateMode: autovalidateMode,
            enabled: enabled,
            builder: (FormFieldState<String> field) {
              void onChangedHandler(String value, PickedFile file) {
                if (onSelectChanged != null) {
                  onSelectChanged(value, file);
                }
                field.didChange(value);
              }

              return ImageField(
                value: field.value,
                decoration: decoration,
                onSelected: onChangedHandler,
                labelText: labelText,
                prefix: prefix,
              );
            });

  @override
  _ImageFormFieldState createState() => _ImageFormFieldState();
}

class _ImageFormFieldState extends FormFieldState<String> {}

class ImageField extends StatelessWidget {
  const ImageField(
      {required this.labelText,
      this.height,
      this.noBorder = false,
      this.prefix,
      this.value,
      this.decoration,
      this.onSelected,
      Key? key})
      : super(key: key);

  final String? value;

  final InputDecoration? decoration;

  final Function(String, PickedFile)? onSelected;

  final double? height;

  final bool noBorder;

  final Widget? prefix;

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? 100,
        decoration: BoxDecoration(
            color: Colors.white,
            border: noBorder
                ? null
                : Border(
                    bottom: BorderSide(width: 1, color: Colors.grey[200]!))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.getImage(
                        source: ImageSource.gallery, imageQuality: 65);

                    if (pickedFile != null) {
                      if (onSelected != null)
                        onSelected!(pickedFile.path, pickedFile);
                    }
                  },
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.white,
                        backgroundImage: (value != null &&
                                !value!.contains('/finance_tag_icons'))
                            ? FileImage(
                                File(value!),
                              )
                            : null,
                        child: value == null
                            ? null
                            : Padding(
                                padding: EdgeInsets.all(4),
                                child: (value != null &&
                                        !value!.contains('/finance_tag_icons'))
                                    ? Container()
                                    : Image.network(
                                        '${Config().server}$value')))
                  ]))),
          Padding(padding: EdgeInsets.only(right: 4))
        ]));
  }
}
