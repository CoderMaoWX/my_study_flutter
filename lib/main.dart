import 'package:flutter/material.dart';
import 'package:my_study_flutter/model/video_model.dart';
import 'package:my_study_flutter/page/home_page.dart';
import 'package:my_study_flutter/page/video_detail_page.dart';

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
  BiliRouteInformationParser _informationParser = BiliRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    var widget = Router(
      routeInformationParser: _informationParser,
      routerDelegate: _routeDelegate,
      routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(location: "/")),
    );

    return MaterialApp(
      home: widget,
    );
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  var pages = <MaterialPage>[];
  // Nullable fields initialized to null to satisfy the analyzer.
  VideoModel? videoModel = null;
  BiliRoutePath? path = null;
  @override
  Widget build(BuildContext context) {
    pages = [
      pageWrap(HomePage(
        onJumpToDatail: (VideoModel value) {
          this.videoModel = value;
          notifyListeners();
        },
      )),
      if (videoModel != null)
        pageWrap(VideoDetailPage(videoModel: videoModel!)) // Null-check here
    ];

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {
    this.path = path;
  }
}

class BiliRouteInformationParser extends RouteInformationParser<BiliRoutePath> {
  @override
  Future<BiliRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = routeInformation.uri; // Uri.parse(routeInformation.location);
    print('uri: $uri');
    if (uri.pathSegments.isEmpty) {
      return BiliRoutePath.home();
    }
    return BiliRoutePath.detail();
  }
}

///定义路由数据 path
class BiliRoutePath {
  final String location;

  BiliRoutePath.home() : location = "/";

  BiliRoutePath.detail() : location = "/detail";
}

///创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}
