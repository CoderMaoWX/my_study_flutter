import 'package:flutter/material.dart';
import 'package:my_study_flutter/util/view_util.dart';

class NavigationBar extends StatelessWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget child;

  const NavigationBar(
      {super.key,
      this.statusStyle = StatusStyle.LIGHT_CONTENT,
      required this.color,
      required this.height,
      required this.child});

  @override
  Widget build(BuildContext context) {
    _statusBarInit();
    var top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + height,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: color),
      child: child,
    );
  }

  void _statusBarInit() {
    //沉浸式状态栏
    changeStatusBar(color: color, statusStyle: statusStyle);
  }
}
