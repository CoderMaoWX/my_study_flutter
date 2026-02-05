import 'package:my_study_flutter/http/dao/login_dao.dart';

enum HttpMethod { GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS }

///基础请求

abstract class BaseRequest {
  var pathParams;
  var useHttps = true;

  String authority() {
    return "api.devio.org";
  }

  HttpMethod httpMethod();

  String path();

  String url() {
    Uri uri;
    var pathStr = path();
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }

    if (needLogin()) {
      //给需要登录的接口携带登录令牌
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }

    //http or https
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    //print("请求URL：${uri.toString()}");
    return uri.toString();
  }

  bool needLogin();

  Map<String, String> params = {};
  //添加参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = {
    'course-flag': 'fa',
    'auth-token': 'ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa',
  };
  //添加请求头
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
