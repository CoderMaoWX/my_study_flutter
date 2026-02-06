import 'package:flutter/material.dart';

import '../page/home_page.dart';
import '../page/login_page.dart';
import '../page/registration_page.dart';
import '../page/video_detail_page.dart';

typedef RouteChangeListener(RouteStatusInfo current, RouteStatusInfo? child);

///创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

///获取routeStatus页面在堆栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (var i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

///自定义路由
enum RouteStatus { login, registration, home, detail, unknown }

///获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

///路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

class HiNavigator extends _RouteJumpListener {
  static HiNavigator? _instance;

  RouteJumpListener? _jumpListener;
  List<RouteChangeListener> _listener = [];
  RouteStatusInfo? _current;

  HiNavigator._();

  static HiNavigator getInstance() {
    _instance ??= HiNavigator._();
    return _instance!;
  }

  void registerRouteJump(RouteJumpListener listener) {
    this._jumpListener = listener;
  }

  @override
  void onJump(RouteStatus routeStatus, {Map? args}) {
    _jumpListener?.onJumpTo(routeStatus, args: args);
  }

  void addListener(RouteChangeListener listener) {
    if (!_listener.contains(listener)) {
      _listener.add(listener);
    }
  }

  void removeListener(RouteChangeListener listener) {
    _listener.remove(listener);
  }

  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;
    var current =
        RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  void _notify(RouteStatusInfo current) {
    print('导航器：当前页面：${current.page}');
    print('导航器：上一个页面：${_current?.page}');

    _listener.forEach((listener) {
      listener(current, _current);
    });
    _current = current;
  }
}

abstract class _RouteJumpListener {
  void onJump(RouteStatus routeStatus, {Map args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener({required this.onJumpTo});
}
