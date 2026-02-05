///需要登录的异常类
class NeedLogin extends HiNetError {
  NeedLogin({int code = 401, String message = "清先登录"}) : super(code, message);
}

///需要授权的异常类
class NeedAuth extends HiNetError {
  NeedAuth(String message, {int code = 403, dynamic data})
      : super(code, message, data: data);
}

///网络请求错误类
class HiNetError implements Exception {
  final int code;
  final String message;
  final dynamic data;

  HiNetError(this.code, this.message, {this.data});

  @override
  String toString() {
    return "HiNetError{code: $code, message: $message}";
  }
}
