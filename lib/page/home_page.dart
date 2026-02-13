import 'package:flutter/material.dart' hide NavigationBar;
import 'package:my_study_flutter/http/core/hi_error.dart';
import 'package:my_study_flutter/http/dao/home_dao.dart';
import 'package:my_study_flutter/page/home_tab_page.dart';
import 'package:my_study_flutter/util/color.dart';
import 'package:my_study_flutter/util/toast.dart';
import 'package:my_study_flutter/util/view_util.dart';
import 'package:my_study_flutter/widget/navigation_bar.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../model/home_mo.dart';
import '../navigator/hi_navigator.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onHeaderJumpTo;
  const HomePage({super.key, required this.onHeaderJumpTo});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var listener;
  late TabController _controller;
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: categoryList.length, vsync: this);
    HiNavigator.getInstance().addListener(listener = (current, pre) {
      print("home: current: ${current.page}");
      print("home: pre: ${pre.page}");
      if (widget == current.page || current.page is HomePage) {
        print("打开了首页: onResume");
      } else if (widget == pre.page || pre.page is HomePage) {
        print("打开了首页: onPause");
      }
    });
    loadData();
  }

  void loadData() async {
    try {
      HomeMo result = await HomeDao.get("推荐");
      print("加载首页分类数据: ${result}");
      if (result.categoryList != null) {
        _controller = TabController(
            length: result.categoryList?.length ?? 0, vsync: this);
        setState(() {
          categoryList = result.categoryList ?? [];
          bannerList = result.bannerList ?? [];
          _isLoading = false;
        });
      }
    } on NeedAuth catch (e) {
      debugPrint(e.message.toString());
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    } on NeedLogin catch (e) {
      debugPrint(e.message.toString());
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          NavigationBar(
            height: 46,
            color: Colors.white,
            statusStyle: StatusStyle.DARK_CONTENT,
            child: _appBar(),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 10),
            child: _tabBar(),
          ),
          Flexible(
              child: TabBarView(
                  controller: _controller,
                  children: categoryList.map((tab) {
                    return HomeTabPage(
                        categoryName: tab.name,
                        bannerList: tab.name == '推荐' ? bannerList : null);
                  }).toList()))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget? _tabBar() {
    return TabBar(
        controller: _controller,
        isScrollable: true,
        labelColor: Colors.black,
        indicator: UnderlineIndicator(
            strokeCap: StrokeCap.round,
            borderSide: BorderSide(color: primary, width: 3),
            insets: EdgeInsets.only(left: 15, right: 15)),
        tabs: categoryList.map<Tab>((tab) {
          return Tab(
              child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab.name,
              style: TextStyle(fontSize: 16),
            ),
          ));
        }).toList());
  }

  Widget _appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.onHeaderJumpTo != null) {
                widget.onHeaderJumpTo!(3);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Image(
                  image: AssetImage('images/avatar.png'),
                  width: 46,
                  height: 46),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 32,
              color: Colors.grey[100],
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsetsGeometry.only(left: 10),
                child: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          )),
          SizedBox(width: 15),
          Icon(Icons.explore_outlined, color: Colors.grey),
          SizedBox(width: 15),
          Icon(Icons.mail_outline, color: Colors.grey),
        ],
      ),
    );
  }
}
