import 'package:flutter/material.dart';
import 'package:my_study_flutter/db/hi_cache.dart';
import 'package:my_study_flutter/page/login_page.dart';
import 'package:my_study_flutter/util/color.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    HiCache.preInit();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: white,
      ),
      home: LoginPage(),
    );
  }
}
