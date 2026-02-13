import 'package:flutter/cupertino.dart';
import 'package:my_study_flutter/http/core/dio_adapter.dart';
import 'package:my_study_flutter/http/core/hi_error.dart';
import 'package:my_study_flutter/http/core/ni_net_adapter.dart';
import 'package:my_study_flutter/http/request/base_request.dart';

class HiNet {
  HiNet._();

  static HiNet? _instance;
  static HiNet getInstance() {
    _instance ??= HiNet._();
    return _instance!;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse? response;
    Object? error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
    } catch (e) {
      //其他异常
      error = e;
      printLog("错误信息：$e");
    }

    var result = response?.data;
    if (response == null) {
      printLog("❌❌❌失败响应：$error");
    } else {
      printLog("✅✅✅成功响应：$result");
    }
    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(response.toString(), data: result);
      default:
        throw HiNetError(status ?? 444, response.toString(), data: result);
    }
  }

  Future<dynamic> send<T>(BaseRequest request) async {
    printLog("URL：${request.url()}");
    printLog("Method：${request.httpMethod()}");
    // request.addHeader("token", "123");
    // printLog("header: ${request.header}");

    // HiNetAdapter adpater = MockAdapter();
    HiNetAdapter adpater = DioAdapter();
    return adpater.send(request);
  }

  void printLog(log) {
    const chunkSize = 800;
    for (var i = 0; i < log.length; i += chunkSize) {
      debugPrint(log.substring(
        i,
        i + chunkSize > log.length ? log.length : i + chunkSize,
      ));
    }
    // debugPrint("网络请求 ${log.toString()}");
  }
}
