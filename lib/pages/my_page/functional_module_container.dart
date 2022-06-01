import 'package:flutter/material.dart';

// 功能模块容器
class FunctionalModuleContainer extends StatelessWidget {
  final Widget title;
  final Widget? prefix;
  final String? rightText;
  final Widget? content;
  final Decoration? decoration;
  final Function()? onTap;
  FunctionalModuleContainer(
      {required this.title,
      this.rightText,
      this.prefix,
      this.content,
      this.decoration,
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: decoration ??
            BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: const Color(0xffe5e5e5)))),
        child: new Material(
            color: Colors.white,
            child: InkWell(
                splashColor: Colors.grey.withAlpha(30),
                highlightColor: Colors.white30,
                onTap: onTap,
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    child: Column(children: [
                      DefaultTextStyle(
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                prefix != null
                                    ? Container(
                                        padding: EdgeInsets.only(right: 8),
                                        child: prefix)
                                    : Container(),
                                title
                              ]),
                              Row(
                                children: [
                                  Text(rightText ?? '',
                                      style:
                                          TextStyle(color: Colors.grey[400])),
                                  Icon(Icons.keyboard_arrow_right,
                                      color: Colors.grey[400])
                                ],
                              )
                            ],
                          )),
                      content != null
                          ? Container(
                              padding: EdgeInsets.only(top: 12), child: content)
                          : Container()
                    ])))));
  }
}
