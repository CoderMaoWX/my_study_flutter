import 'package:flutter/material.dart';
import 'package:my_study_flutter/model/video_model.dart';

import '../navigator/hi_navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
      ),
      body: Container(
        child: Column(
          children: [
            Text('首页信息'),
            MaterialButton(
              onPressed: () {
                HiNavigator.getInstance().onJump(RouteStatus.detail,
                    args: {"videoMo": VideoModel(111)});
              },
              child: Text('进入详情'),
            )
          ],
        ),
      ),
    );
  }
}
