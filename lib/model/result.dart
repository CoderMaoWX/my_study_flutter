import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

@JsonSerializable()
class Result {
  int code;
  String method;
  String requestPrams;

  Result(this.code, this.method, this.requestPrams);

  //固定的格式
  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  //固定的格式
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
