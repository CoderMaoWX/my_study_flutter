import 'package:flutter/material.dart';
import 'package:my_study_flutter/page/login_effect.dart';
import 'package:my_study_flutter/widget/appbar.dart';
import 'package:my_study_flutter/widget/input_textField.dart';
import 'package:my_study_flutter/widget/login_button.dart';

import '../http/core/hi_error.dart';
import '../http/dao/login_dao.dart';
import '../util/string_util.dart';
import '../util/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  late String userName;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar("密码登录", "注册", () {}),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput("用户名", "请输入用户名", onChanged: (text) {
              userName = text;
              checkInput();
            }, focusChanged: (focs) {
              setState(() {
                protect = focs;
              });
            }, keyboardType: TextInputType.text),
            SizedBox(width: 15),
            LoginInput("密码", "请输入密码", obscureText: true, onChanged: (text) {
              password = text;
              checkInput();
            }, focusChanged: (focs) {
              setState(() {
                protect = focs;
              });
            }, keyboardType: TextInputType.text),
            SizedBox(width: 15),
            Padding(
              padding: EdgeInsets.all(20),
              child: LoginButton("登录", enable: loginEnable, onPressed: () {
                checkParams();
              }),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable = false;
    if (isNotEmpty(userName) && isNotEmpty(password)) {
      enable = true;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void checkParams() {
    String? tips = null;
    if (userName == null) {
      tips = "账号不能为空";
    } else if (password == null) {
      tips = "密码不能为空";
    }
    if (tips != null) {
      print(tips);
      showWarnToast(tips);
    } else {
      _requestLogin();
    }
  }

  ///登录接口
  void _requestLogin() async {
    try {
      var result = await LoginDao.login(userName, password);
      if (result["code"] == 0) {
        print("登录成功");
        showToast("登录成功");
      } else {
        print(result);
        showWarnToast(result["msg"]);
      }
    } on NeedAuth catch (e) {
      print('NeedAuth: ${e.message} ');
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print('HiNetError: ${e.message} ');
      showWarnToast(e.message);
    }
  }
}
