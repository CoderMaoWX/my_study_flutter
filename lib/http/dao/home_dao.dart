import 'package:my_study_flutter/http/core/hi_net.dart';
import 'package:my_study_flutter/http/request/home_request.dart';
import 'package:my_study_flutter/model/home_mo.dart';

class HomeDao {
  static get(String categoryName, {int pageIndex = 1, int pageSize = 1}) async {
    HomeRequest request = HomeRequest();
    request.pathParams = categoryName;
    request.add("pageIndex", pageIndex);
    request.add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    print("首页分类数据: ${result}");
    return HomeMo.fromJson(result["data"]);
  }
}
