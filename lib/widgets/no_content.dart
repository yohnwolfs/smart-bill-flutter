import 'package:flutter/material.dart';

class NoContent extends StatelessWidget {
  const NoContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'images/no_content.png',
            width: 200,
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
          ),
          Text('没有数据', style: TextStyle(fontSize: 16, color: Colors.grey[500]))
        ]));
  }
}
