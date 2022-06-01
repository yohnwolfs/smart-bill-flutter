import 'package:account_book/navigator/tab_navigator.dart';
import 'package:account_book/pages/book_manage_page/book_finance_list.dart';
import 'package:account_book/pages/finance_book_creator.dart';
import 'package:account_book/pages/finance_creator.dart';
import 'package:account_book/pages/finance_detail_page.dart';
import 'package:account_book/pages/login.dart';
import 'package:account_book/pages/my_page/setting_page.dart';
import 'package:account_book/pages/my_page/tag_detail_page.dart';
import 'package:account_book/pages/my_page/tag_manage_page.dart';
import 'package:account_book/pages/notification_page.dart';

final routes = {
  "login": (context) => LoginPage(),
  "finance_creator": (context) => FinanceCreatorPage(),
  "finance_book_creator": (context) => FinanceBookCreatorPage(),
  "finance_detail": (context) => FinanceDetailPage(),
  "book_finance_list": (context) => BookFinanceList(),
  "setting": (context) => SettingPage(),
  "notification": (context) => NotificationPage(),
  "tag_manage": (context) => TagManagePage(),
  "tag_detail": (context) => TagDetailPage()
};

final rootRoutes = {
  "/": (context) => TabNavigator(),
};

final wholeRoutes = {
  ...rootRoutes,
  ...routes,
};
