import 'package:account_book/state/auth_state.dart';
import 'package:account_book/state/finance.dart';
import 'package:account_book/state/finance_book.dart';
import 'package:account_book/state/finance_statistics.dart';
import 'package:account_book/state/finance_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import './navigator/tab_navigator.dart';
import 'navigator/navigation_util.dart';
import 'navigator/routes.dart';

void main() async {
  // 确保sputil可用
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();

  // 强制竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    // providers
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider.value(value: AuthState()),
      ChangeNotifierProvider.value(value: FinanceBookState()),
      ChangeNotifierProvider.value(value: FinanceTagState()),
      ChangeNotifierProvider.value(value: FinanceState()),
      ChangeNotifierProvider.value(value: FinanceStatisticsState()),
    ], child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [NavigationUtil.getInstance()],
      theme: ThemeData(
        primaryColor: const Color(0xFFf2a90e),
        primarySwatch: createMaterialColor(const Color(0xFFf2a90e)),
        brightness: Brightness.light,
        accentColor: const Color(0xFFf2a90e),
        backgroundColor: const Color(0xFFf2f2f2),
        cardColor: Colors.white,
        shadowColor: Colors.transparent,
        bottomAppBarColor: const Color(0xff373A36),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: routes,
      home: TabNavigator(),
      supportedLocales: [
        const Locale('en', 'US'), // 美国英语
        const Locale('zh', 'CN'), // 中文简体
        //其它Locales
      ],
      localeListResolutionCallback:
          (List<Locale>? locales, Iterable<Locale> supportedLocales) {
        return Locale('zh');
      },
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        return Locale('zh');
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
