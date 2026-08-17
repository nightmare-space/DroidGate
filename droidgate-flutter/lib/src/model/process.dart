// {
//             "processName": "com.nightmare.adbtools",
//             "importance": 100,
//             "importanceReasonCode": 0,
//             "importanceReasonPid": 0,
//             "lru": 0,
//             "pid": 11712,
//             "uid": 10459
//         },

import 'package:json_annotation/json_annotation.dart';
part 'process.g.dart';

@JsonSerializable()
class AndroidProcesses {
  List<AndroidProcess> datas;
  AndroidProcesses({required this.datas});

  factory AndroidProcesses.fromJson(Map<String, dynamic> json) => _$AndroidProcessesFromJson(json);
  Map<String, dynamic> toJson() => _$AndroidProcessesToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class AndroidProcess {
  AndroidProcess({
    required this.processName,
    required this.importance,
    required this.importanceReasonCode,
    required this.importanceReasonPid,
    required this.lru,
    required this.pid,
    required this.uid,
  });

  @JsonKey(name: 'processName')
  String processName;
  int importance;
  int importanceReasonCode;
  int importanceReasonPid;
  int lru;
  int pid;
  int uid;

  factory AndroidProcess.fromJson(Map<String, dynamic> json) => _$AndroidProcessFromJson(json);
  Map<String, dynamic> toJson() => _$AndroidProcessToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}
