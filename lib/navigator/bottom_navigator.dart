import 'package:flutter/material.dart';
import 'package:my_study_flutter/navigator/hi_navigator.dart';
import 'package:my_study_flutter/page/favorite_page.dart';
import 'package:my_study_flutter/page/home_page.dart';
import 'package:my_study_flutter/page/profile_page.dart';
import 'package:my_study_flutter/page/ranking_page.dart';

import '../util/color.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primary;
  int _currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);
  late List<Widget> _pages;
  bool _hasBuild = false;

  @override
  Widget build(BuildContext context) {
    _pages = [
      HomePage(
        onHeaderJumpTo: (index) => _onJumpTo(index, pageChange: false),
      ),
      RankingPage(),
      FavoritePage(),
      ProfilePage()
    ];
    if (!_hasBuild) {
      //页面第一次打开时通知打开的是那个tab
      HiNavigator.getInstance()
          .onBottomTabChange(_currentIndex, _pages[_currentIndex]);
      _hasBuild = true;
    }

    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) => _onJumpTo(index, pageChange: true),
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        //把 BottomNavigationBar 用 Theme 包裹并设置 splashFactory 为 NoSplash.splashFactory，同时把 highlightColor/splashColor 设为 Colors.transparent，即可去掉点击时的水波纹效果。
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => _onJumpTo(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: _activeColor,
          items: [
            _bottomItem("首页", Icons.home, 0),
            _bottomItem("排行", Icons.local_fire_department, 1),
            _bottomItem("收藏", Icons.favorite, 2),
            _bottomItem("我的", Icons.live_tv, 3),
          ],
        ),
      ),
    );
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(icon, color: _defaultColor),
        activeIcon: Icon(icon, color: _activeColor),
        label: title);
  }

  void _onJumpTo(int index, {pageChange = false}) {
    if (!pageChange) {
      //让PageView展示对应tab
      _controller.jumpToPage(index);
    } else {
      HiNavigator.getInstance().onBottomTabChange(index, _pages[index]);
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
