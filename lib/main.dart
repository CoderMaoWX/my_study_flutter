import 'package:flutter/material.dart';
import 'package:my_study_flutter/page/registration_page.dart';
import 'package:my_study_flutter/util/color.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: white,
      ),
      home: RegistrationPage(),
    );
  }
}
