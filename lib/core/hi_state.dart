import 'package:flutter/material.dart';

abstract class HiState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    } else {
      print('HiState:页面已销毁，本次setState不执行：${toString()}');

      ///可以在这里做埋点操作
    }
  }
}
