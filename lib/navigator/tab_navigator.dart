import 'package:account_book/dao/finance_dao.dart';
import 'package:account_book/navigator/navigation_util.dart';
import 'package:account_book/pages/chart_page/index.dart';
import 'package:account_book/pages/book_manage_page/index.dart';
import 'package:account_book/state/auth_state.dart';
import 'package:account_book/state/finance.dart';
import 'package:account_book/state/finance_book.dart';
import 'package:account_book/state/finance_tag.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/home_page/index.dart';
import '../pages/my_page/index.dart';

class TabNavigator extends StatefulWidget {
  @override
  TabNavigatorState createState() => TabNavigatorState();
}

class TabNavigatorState extends State<TabNavigator>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();

    // 初始化tab页面控制器
    _controller = PageController(initialPage: 0, keepPage: true);

    // 初始化权限
    initAuth();

    // 初始化全局数据
    initGlobalData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void initAuth() {
    Provider.of<AuthState>(context, listen: false).getUserInfo();
  }

  void initGlobalData() {
    Provider.of<FinanceBookState>(context, listen: false).fetchFinanceBooks();
    Provider.of<FinanceTagState>(context, listen: false).fetchFinanceTags();
  }

  void centerAdditionHandler() {
    if (_currentIndex == 1) {
      // 账本管理页
      addFinanceBook();
    } else {
      // 其他页面
      addFinance();
    }
  }

  // 添加账单
  void addFinance() async {
    final res = await NavigationUtil.getInstance().pushNamed(
      'finance_creator',
    );

    if (res == null) return;

    await FinanceDao().addFinance({
      'amount': res.amount,
      'goods': res.desc ?? res.tag.name,
      'tradingTime': res.date.millisecondsSinceEpoch,
      'tradingType': res.tag.type,
      'tags': [res.tag.id]
    });

    Provider.of<FinanceState>(context, listen: false).reloadFinances();
  }

  // 添加账本
  void addFinanceBook() async {
    final res = await NavigationUtil.getInstance().pushNamed(
      'finance_book_creator',
    );

    if (res == null) return;

    Provider.of<FinanceBookState>(context, listen: false).addFinanceBook(res);
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
            toolbarHeight: 0,
            shadowColor: Theme.of(context).shadowColor,
            backgroundColor: Theme.of(context).shadowColor,
            actions: []),
        body: PageView(
          controller: _controller,
          children: <Widget>[
            HomePage(),
            BookManagePage(),
            ChartPage(),
            MyPage()
          ],
          physics: NeverScrollableScrollPhysics(),
        ),
        // drawer: Drawer(),
        floatingActionButton: FloatingActionButton(
            onPressed: centerAdditionHandler,
            tooltip: '添加账单',
            child: Icon(Icons.add, size: 30),
            elevation: 0),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: [Icons.home, Icons.book, Icons.pie_chart, Icons.people],
          inactiveColor: const Color(0xFFffffff),
          activeColor: Theme.of(context).accentColor,
          splashColor: Theme.of(context).accentColor,
          backgroundColor: Theme.of(context).bottomAppBarColor,
          activeIndex: _currentIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.defaultEdge,
          // leftCornerRadius: 32,
          // rightCornerRadius: 32,
          onTap: (index) {
            _controller.jumpToPage(index);
            setState(() => _currentIndex = index);
          },
          //other params
        ));
  }
}
