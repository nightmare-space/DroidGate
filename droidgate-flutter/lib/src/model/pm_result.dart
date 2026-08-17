import 'package:json_annotation/json_annotation.dart';

part 'pm_result.g.dart';

// {
//      "stdout": "",
//      "stderr": ""
// }
@JsonSerializable()
class PMResult {
  PMResult({
    required this.stdout,
    required this.stderr,
  });

  String stdout;
  String stderr;

  factory PMResult.fromJson(Map<String, dynamic> json) => _$PMResultFromJson(json);
  Map<String, dynamic> toJson() => _$PMResultToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}
