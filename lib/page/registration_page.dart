import 'package:flutter/material.dart';
import 'package:my_study_flutter/http/core/hi_error.dart';
import 'package:my_study_flutter/http/dao/login_dao.dart';
import 'package:my_study_flutter/page/login_effect.dart';
import 'package:my_study_flutter/util/string_util.dart';
import 'package:my_study_flutter/widget/appbar.dart';
import 'package:my_study_flutter/widget/input_textField.dart';

import '../db/hi_cache.dart';
import '../navigator/hi_navigator.dart';
import '../util/toast.dart';
import '../widget/login_button.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false;
  late String userName;
  late String password;
  late String rePassword;
  late String imoocId;
  late String orderId;

  @override
  Widget build(BuildContext context) {
    HiCache.preInit();
    return Scaffold(
        appBar: appbar("注册", "登录", () {
          HiNavigator.getInstance().onJump(RouteStatus.login);
        }),
        body: Container(
          child: ListView(
            children: [
              LoginEffect(protect: protect),
              SizedBox(height: 15),
              LoginInput("用户名", "请输入用户名", onChanged: (text) {
                userName = text;
                checkInput();
              }, focusChanged: (focus) {
                debugPrint('focus: $focus');
                setState(() {
                  protect = focus;
                });
              }, keyboardType: TextInputType.emailAddress),
              SizedBox(height: 15),
              LoginInput("密码", "请输入密码", lineStretch: true, obscureText: true,
                  onChanged: (text) {
                password = text;
                checkInput();
              }, focusChanged: (focus) {
                setState(() {
                  protect = focus;
                });
              }, keyboardType: TextInputType.emailAddress),
              SizedBox(width: 15),
              LoginInput("确认密码", "请重新输入密码", obscureText: true,
                  onChanged: (text) {
                rePassword = text;
                checkInput();
              }, focusChanged: (focus) {
                setState(() {
                  protect = focus;
                });
              }, keyboardType: TextInputType.emailAddress),
              SizedBox(width: 15),
              LoginInput("慕课网ID", "请输入你的慕课网ID", onChanged: (text) {
                imoocId = text;
                checkInput();
              }, focusChanged: (focus) {
                setState(() {
                  protect = focus;
                });
              }, keyboardType: TextInputType.number),
              SizedBox(width: 15),
              LoginInput("课程订单号", "请输入你的课程订单号后4位", lineStretch: true,
                  onChanged: (text) {
                orderId = text;
                checkInput();
              }, focusChanged: (focus) {
                setState(() {
                  protect = focus;
                });
              }, keyboardType: TextInputType.number),
              Padding(
                padding: EdgeInsets.all(20),
                child: LoginButton("登录", enable: loginEnable, onPressed: () {
                  _registerButton();
                }),
              )
            ],
          ),
        ));
  }

  void checkInput() {
    bool enable = false;
    if (isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(imoocId) &&
        isNotEmpty(orderId)) {
      enable = true;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  _registerButton() {
    return InkWell(
      onTap: () {
        if (loginEnable) {
          checkParams();
        } else {
          print("Toast: 检验参数不合法");
          showWarnToast("检验参数不合法");
        }
      },
      child: Text("注册"),
    );
  }

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = "两次密码不一致";
    } else if (orderId.length != 4) {
      tips = "请输入订单号后四位";
    }
    if (tips != null) {
      print(tips);
      showWarnToast(tips);
    } else {
      requestRegister();
    }
  }

  ///注册接口
  void requestRegister() async {
    try {
      var result =
          await LoginDao.registration(userName, password, imoocId, orderId);
      print(result);
      if (result["code"] == 0) {
        print("注册成功");
        showToast("注册成功");
        HiNavigator.getInstance().onJump(RouteStatus.login);
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
