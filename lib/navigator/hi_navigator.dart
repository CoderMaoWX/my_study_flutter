import 'package:flutter/material.dart';
import 'package:my_study_flutter/navigator/bottom_navigator.dart';

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
  } else if (page.child is BottomNavigator) {
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
  //首页底部tab
  RouteStatusInfo? _bottomTab;

  HiNavigator._();

  static HiNavigator getInstance() {
    _instance ??= HiNavigator._();
    return _instance!;
  }

  void registerRouteJump(RouteJumpListener listener) {
    this._jumpListener = listener;
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _jumpListener?.onJumpTo(routeStatus, args: args);
  }

  ///首页底部tab切换监听
  void onBottomTabChange(int index, Widget page) {
    _bottomTab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomTab!);
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
    if (current.page is BottomNavigator && _bottomTab != null) {
      //如果打开的是首页，则明确到首页具体的tab
      current = _bottomTab!;
    }

    print('导航器：当前页面：${current.page}');
    print('导航器：上一个页面：${_current?.page}');

    for (var listener in _listener) {
      listener(current, _current);
    }
    _current = current;
  }
}

abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener({required this.onJumpTo});
}
