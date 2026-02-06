import 'package:flutter/material.dart';
import 'package:my_study_flutter/http/dao/login_dao.dart';
import 'package:my_study_flutter/model/video_model.dart';
import 'package:my_study_flutter/navigator/hi_navigator.dart';
import 'package:my_study_flutter/page/home_page.dart';
import 'package:my_study_flutter/page/login_page.dart';
import 'package:my_study_flutter/page/registration_page.dart';
import 'package:my_study_flutter/page/video_detail_page.dart';
import 'package:my_study_flutter/util/toast.dart';

import 'db/hi_cache.dart';

void main() {
  runApp(BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({super.key});
  @override
  State<BiliApp> createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
        //进行初始化工作
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(routerDelegate: _routeDelegate)
              : Scaffold(body: Center(child: CircularProgressIndicator()));
          return MaterialApp(
            home: widget,
            theme: ThemeData(primaryColor: Colors.blue),
          );
        });
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    HiNavigator.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        this.videoModel = args!['videoMo'];
      }
      notifyListeners();
    }));
  }
  RouteStatus _routeStatus = RouteStatus.home;

  var pages = <MaterialPage>[];
  // Nullable fields initialized to null to satisfy the analyzer.
  VideoModel? videoModel;
  BiliRoutePath? path;

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, currentRouteStatus);
    var tempPages = pages;
    if (index != -1) {
      //要打开的页面在栈中已存在，则将该页面和它上面的所有页面进行出栈
      //tps具体规则可以根据需要进行调整，这里要求栈中只允许有一个同样的页面的实例
      tempPages = tempPages.sublist(0, index);
    }
    var page;

    if (currentRouteStatus == RouteStatus.home) {
      //跳转首页时将栈中的其他页面都出栈, 因为首页不能出栈
      pages.clear();
      page = pageWrap(HomePage());
    } else if (currentRouteStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel: videoModel!));
    } else if (currentRouteStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage());
    } else if (currentRouteStatus == RouteStatus.login) {
      page = pageWrap(LoginPage());
    }

    //重新创建一个数组，否则pages因引用没有改变路由不会生效
    tempPages = [...tempPages, page];
    pages = tempPages;

    return WillPopScope(
        onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            if (route.settings is MaterialPage) {
              if ((route.settings as MaterialPage).child is LoginPage) {
                if (!hasLogin) {
                  showWarnToast("请先登录");
                  return false;
                }
              }
            }
            //执行返回操作
            if (!route.didPop(result)) {
              return false;
            }
            pages.removeLast();
            return true;
          },
        ));
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;

  RouteStatus get currentRouteStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {}
}

///定义路由数据 path
class BiliRoutePath {
  final String location;

  BiliRoutePath.home() : location = "/";

  BiliRoutePath.detail() : location = "/detail";
}
