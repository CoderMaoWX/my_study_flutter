import 'package:flutter/material.dart';
import 'package:my_study_flutter/model/video_model.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<VideoModel> onJumpToDatail;

  const HomePage({super.key, required this.onJumpToDatail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text('首页'),
            MaterialButton(
              onPressed: () => widget.onJumpToDatail(VideoModel(111)),
              child: Text('详情'),
            )
          ],
        ),
      ),
    );
  }
}
