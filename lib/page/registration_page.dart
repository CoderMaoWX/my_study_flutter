import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_study_flutter/http/core/hi_error.dart';
import 'package:my_study_flutter/http/core/hi_net.dart';
import 'package:my_study_flutter/http/dao/login_dao.dart';
import 'package:my_study_flutter/page/login_effect.dart';
import 'package:my_study_flutter/util/string_util.dart';
import 'package:my_study_flutter/widget/appbar.dart';
import 'package:my_study_flutter/widget/input_textField.dart';

import '../db/hi_cache.dart';
import '../http/request/notice_request.dart';
import '../model/owner.dart';
import '../util/toast.dart';
import '../widget/login_button.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback onJumpToLogin;

  const RegistrationPage({super.key, required this.onJumpToLogin});

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
        appBar: appbar("注册", "登录", widget.onJumpToLogin),
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
    String? tips = null;
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
        if (widget.onJumpToLogin != null) {
          widget.onJumpToLogin();
        } else {
          print(result["msg"]);
          showWarnToast(result["msg"]);
        }
      }
    } on NeedAuth catch (e) {
      print('NeedAuth: ${e.message} ');
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print('HiNetError: ${e.message} ');
      showWarnToast(e.message);
    }
  }

  void _testRequest() async {
    // TestRequest request = TestRequest();
    // request.add("name", "hyman").add("age", 18).add("requestPrams", "kkk");
    //
    // try {
    //   var result = await HiNet.getInstance().fire(request);
    //   print(result);
    // } on NeedAuth catch (e) {
    //   print('NeedAuth: ${e.message} ');
    // } on NeedLogin catch (e) {
    //   print('NeedLogin: ${e.message} ');
    // } on HiNetError catch (e) {
    //   print('HiNetError: ${e.message} ');
    // }

    // test();
    // test1();
    // test2();
    // testLogin();
    noticeRequest();
  }

  ///测试: 获取通知接口
  void noticeRequest() async {
    try {
      var notice = await HiNet.getInstance().fire(NoticeRequest());
      print(notice);
    } on NeedAuth catch (e) {
      print(e);
    } on NeedLogin catch (e) {
      print(e);
    } on HiNetError catch (e) {
      print(e.message);
    }
  }

  void testLogin() async {
    try {
      //注册接口
      // var result = await LoginDao.registration("luocheng2025", "Zm920118.com", "11742267", "6211");
      //登录接口
      var result = await LoginDao.login("luocheng2025", "Zm920118.com");
      print(result);
    } on NeedAuth catch (e) {
      print('NeedAuth: ${e.message} ');
    } on HiNetError catch (e) {
      print('HiNetError: ${e.message} ');
    }
  }

  void test() {
    print('test');
    const jsonString =
        "{ \"name\": \"flutter\", \"url\": \"https://coding.imooc.com/class/487.html\" }";
    //json转map
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    print('json转map: name:${jsonMap['name']}');
    print('json转map: url:${jsonMap['url']}');

    //map转json
    String json = jsonEncode(jsonMap);
    print('map转json:$json');
  }

  void test1() {
    print('test1');
    var ownerMap = {
      "name": "伊零Onezero",
      "face":
          "http://i2.hdslb.com/bfs/face/1c57a17a7b077ccd19dba58a981a673799b85aef.jpg",
      "fans": 0
    };

    //在线自动生成model类1: https://javiercbk.github.io/json_to_dart/
    //在线自动生成model类2: https://www.geekailab.com/io/tools/json-to-dart/

    //map转mo
    Owner owner = Owner.fromJson(ownerMap);
    print('map转mo: name:${owner.name}');
    print('map转mo: face:${owner.face}');
    print('map转mo: fans:${owner.fans}');

    //利用工具生成的mo类: https://www.imooc.com/wiki/Flutter/3json.html
    // Result result = Result.fromJson(ownerMap);

    //mo转map
    Map<String, dynamic> ownerToMap = owner.toJson();
    print('mo转map: name:${ownerToMap['name']}');
    print('mo转map: face:${ownerToMap['face']}');
    print('mo转map: fans:${ownerToMap['fans']}');
  }

  void test2() {
    print('test2');
    HiCache.preInit();
    HiCache.getInstance().setString("luke", "我是路克");
    String? value = HiCache.getInstance().get("luke");
    print('缓存取值: $value');
  }
}
