import 'package:json_annotation/json_annotation.dart';
part 'default_map.g.dart';

// {
//     "result": "success"
// }
@JsonSerializable()
class DefaultResult {
  DefaultResult({
    required this.result,
  });

  String result;

  factory DefaultResult.fromJson(Map<String, dynamic> json) => _$DefaultResultFromJson(json);
  Map<String, dynamic> toJson() => _$DefaultResultToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class DefaultListResult {
  DefaultListResult({
    required this.datas,
  });

  List<dynamic> datas;

  factory DefaultListResult.fromJson(Map<String, dynamic> json) => _$DefaultListResultFromJson(json);
  Map<String, dynamic> toJson() => _$DefaultListResultToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}
