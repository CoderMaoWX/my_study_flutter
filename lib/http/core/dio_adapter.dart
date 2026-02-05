import 'package:dio/dio.dart';
import 'package:my_study_flutter/http/core/hi_error.dart';
import 'package:my_study_flutter/http/core/ni_net_adapter.dart';
import 'package:my_study_flutter/http/request/base_request.dart';

///Dio适配器

class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    var response, options = Options(headers: request.header);
    DioException? error;

    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url(), options: options);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio()
            .post(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.PUT) {
        response = await Dio()
            .put(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await Dio()
            .delete(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.PATCH) {
        response = await Dio()
            .patch(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.HEAD) {
        response = await Dio().head(request.url(), options: options);
      } else if (request.httpMethod() == HttpMethod.OPTIONS) {
        response = Dio().options;
      }
    } on DioException catch (e) {
      error = e;
      response = e.response;
    }
    throw HiNetError(response?.statusCode ?? -1, error.toString() ?? "",
        data: await buildRes(response, request));
    return buildRes(response, request);
  }

  ///构建HiNetResponse
  Future<HiNetResponse<T>> buildRes<T>(
      Response? response, BaseRequest request) {
    return Future.value(HiNetResponse(
        //?.防止response为空
        data: response?.data,
        request: request,
        statusCode: response?.statusCode,
        statusMessage: response?.statusMessage,
        extra: response));
  }
}
