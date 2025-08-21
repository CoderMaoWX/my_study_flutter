import 'package:flutter/material.dart';
import 'package:my_study_flutter/page/login_effect.dart';
import 'package:my_study_flutter/widget/appbar.dart';
import 'package:my_study_flutter/widget/input_textField.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbar("注册", "登录", () {
          debugPrint('right button click');
        }),
        body: Container(
          child: ListView(
            children: [
              LoginEffect(protect: protect),
              SizedBox(height: 15),
              LoginInput("用户名", "请输入用户名", onChanged: (text) {
                debugPrint('text: $text');
              }, focusChanged: (focus) {
                debugPrint('focus: $focus');
              }, keyboardType: TextInputType.emailAddress),
              SizedBox(height: 15),
              LoginInput("密码", "请输入密码", lineStretch: true, onChanged: (text) {
                debugPrint('text: $text');
              }, focusChanged: (focus) {
                debugPrint('focus: $focus');
                setState(() {
                  protect = focus;
                });
              }, keyboardType: TextInputType.emailAddress),
            ],
          ),
        ));
  }
}
