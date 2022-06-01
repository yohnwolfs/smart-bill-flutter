import 'package:account_book/navigator/navigation_util.dart';
import 'package:account_book/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? userName;

  String? password;

  void login() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // try {
      await Provider.of<AuthState>(context, listen: false)
          .login(userName, password);
      Fluttertoast.showToast(msg: '登录成功', gravity: ToastGravity.CENTER);
      NavigationUtil.getInstance().pushReplacementNamed('/');
    }
  }

  Widget buildLoginPanel() {
    return Container(
        height: 500,
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[100]!)),
            color: Theme.of(context).cardColor),
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(children: [
              Padding(padding: EdgeInsets.only(top: 12)),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                      autofocus: true,
                      controller: _unameController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: "用户名或邮箱",
                          prefixIcon: Icon(Icons.person, color: Colors.black)),
                      onSaved: (value) => userName = value,
                      validator: (v) {
                        return v == null || v.trim().length > 0
                            ? null
                            : "用户名不能为空";
                      })),
              Container(
                  margin: EdgeInsets.only(bottom: 30),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      // color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: TextFormField(
                      controller: _pwdController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                          contentPadding: EdgeInsets.all(16),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: "登录密码",
                          prefixIcon: Icon(Icons.lock, color: Colors.black)),
                      obscureText: true,
                      onSaved: (value) => password = value,
                      validator: (v) {
                        return v == null || v.trim().length > 5
                            ? null
                            : "密码不能少于6位";
                      })),
              Container(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    clipBehavior: Clip.hardEdge,
                    onPressed: () {
                      login();
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ))),
                    child: Text("登录", style: TextStyle(fontSize: 18)),
                  ))
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Theme.of(context).shadowColor,
        ),
        body: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(children: <Widget>[
              Expanded(
                  child: Container(
                      child: Stack(children: [
                Positioned(
                    left: -20,
                    bottom: -181,
                    child: Image.asset(
                      'images/big_white.png',
                      width: 300,
                    ))
              ]))),
              buildLoginPanel(),
            ])));
  }
}
