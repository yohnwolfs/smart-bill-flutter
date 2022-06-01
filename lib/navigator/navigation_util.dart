import 'dart:async';

import 'package:account_book/navigator/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteInfo {
  Route? currentRoute;
  List<Route> routes;

  RouteInfo(this.currentRoute, this.routes);

  @override
  String toString() {
    return 'RouteInfo{currentRoute: $currentRoute, routes: $routes}';
  }
}

class NavigationUtil extends NavigatorObserver {
  static NavigationUtil? _instance;

  static Map<String, dynamic> configRoutes = wholeRoutes;

  ///路由信息
  RouteInfo? _routeInfo;
  RouteInfo? get routeInfo => _routeInfo;

  ///stream相关
  // ignore: close_sinks
  static late StreamController<RouteInfo> _streamController;
  StreamController<RouteInfo> get streamController => _streamController;

  ///用来路由跳转
  static late NavigatorState navigatorState;

  static NavigationUtil getInstance() {
    // ignore: unnecessary_null_comparison
    if (_instance == null) {
      _instance = new NavigationUtil();
      _streamController = StreamController<RouteInfo>.broadcast();
    }
    return _instance ?? new NavigationUtil();
  }

  ///push页面
  Future<T?> pushNamed<T>(String routeName,
      {WidgetBuilder? builder, bool? fullscreenDialog, Object? arguments}) {
    return navigatorState.push<T>(
      MaterialPageRoute(
        builder: builder ?? configRoutes[routeName] as dynamic,
        settings: RouteSettings(name: routeName, arguments: arguments),
        fullscreenDialog: fullscreenDialog ?? false,
      ),
      // PageRouteBuilder(
      //     settings: RouteSettings(name: routeName, arguments: arguments),
      //     fullscreenDialog: fullscreenDialog ?? false,
      //     pageBuilder: (context, anim1, anim2) =>
      //         configRoutes[routeName](context),
      //     transitionsBuilder: (_, a, __, c) =>
      //         FadeTransition(opacity: a, child: c))
    );
  }

  ///replace页面
  Future<T?> pushReplacementNamed<T, R>(String routeName,
      {WidgetBuilder? builder, bool? fullscreenDialog, Object? arguments}) {
    return navigatorState.pushReplacement<T, R>(
      MaterialPageRoute(
        builder: builder ?? configRoutes[routeName] as dynamic,
        settings: RouteSettings(name: routeName, arguments: arguments),
        fullscreenDialog: fullscreenDialog ?? false,
      ),
      // PageRouteBuilder(
      //     settings: RouteSettings(name: routeName, arguments: arguments),
      //     fullscreenDialog: fullscreenDialog ?? false,
      //     pageBuilder: (context, anim1, anim2) =>
      //         configRoutes[routeName](context),
      //     transitionsBuilder: (_, a, __, c) =>
      //         FadeTransition(opacity: a, child: c))
    );
  }

  /// pop 页面
  pop<T>([T? result]) {
    navigatorState.pop<T>(result);
  }

  pushNamedAndRemoveUntil(String newRouteName,
      {WidgetBuilder? builder, bool? fullscreenDialog, Object? arguments}) {
    return navigatorState.pushAndRemoveUntil(
        PageRouteBuilder(
            settings: RouteSettings(name: newRouteName, arguments: arguments),
            fullscreenDialog: fullscreenDialog ?? false,
            pageBuilder: (context, anim1, anim2) =>
                configRoutes[newRouteName](context),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c)),
        (Route<dynamic> route) => false);
    // return navigatorState.pushNamedAndRemoveUntil(
    //     newRouteName, (Route<dynamic> route) => false);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    // ignore: unnecessary_null_comparison
    if (_routeInfo == null) {
      _routeInfo = new RouteInfo(null, <Route>[]);
    }

    ///这里过滤调push的是dialog的情况
    if (route is CupertinoPageRoute || route is MaterialPageRoute) {
      _routeInfo?.routes.add(route);
      routeObserver();
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace();
    if (newRoute is CupertinoPageRoute || newRoute is MaterialPageRoute) {
      _routeInfo?.routes.remove(oldRoute);
      if (newRoute != null) _routeInfo?.routes.add(newRoute);
      routeObserver();
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (route is CupertinoPageRoute || route is MaterialPageRoute) {
      _routeInfo?.routes.remove(route);
      routeObserver();
    }
  }

  @override
  void didRemove(Route removedRoute, Route? oldRoute) {
    super.didRemove(removedRoute, oldRoute);
    if (removedRoute is CupertinoPageRoute ||
        removedRoute is MaterialPageRoute) {
      _routeInfo?.routes.remove(removedRoute);
      routeObserver();
    }
  }

  void routeObserver() {
    _routeInfo?.currentRoute = _routeInfo?.routes.last;
    navigatorState = _routeInfo?.currentRoute?.navigator as dynamic;
    if (_routeInfo != null) _streamController.sink.add(_routeInfo!);
  }
}
