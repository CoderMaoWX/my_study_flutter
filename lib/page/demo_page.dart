import 'dart:convert';

import '../db/hi_cache.dart';
import '../http/core/hi_error.dart';
import '../http/core/hi_net.dart';
import '../http/dao/login_dao.dart';
import '../http/request/notice_request.dart';
import '../model/owner.dart';

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
