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

  @override
  Widget build(BuildContext context) {
    _pages = [HomePage(), RankingPage(), FavoritePage(), ProfilePage()];
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _pages,
        onPageChanged: (index) => _onJumpTo(index, pageChange: true),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => _onJumpTo(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: _activeColor,
          items: [
            _bottomItem("首页", Icons.home, 0),
            _bottomItem("排行", Icons.local_fire_department, 1),
            _bottomItem("收藏", Icons.favorite, 2),
            _bottomItem("我的", Icons.live_tv, 3),
          ]),
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
      _controller.jumpToPage(index);
    } else {
      HiNavigator.getInstance().onBottomTabChange(index, _pages[index]);
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
