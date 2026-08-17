import 'package:json_annotation/json_annotation.dart';

part 'cpu_gpu_info.g.dart';
// {
//     "cpu": [
//         "1363200",
//         "1363200",
//         "1363200",
//         "1363200",
//         "1363200",
//         "1363200",
//         "1017600",
//         "2649600"
//     ],
//     "gpu": [
//         "95662",
//         "1016192"
//     ]
// }

@JsonSerializable()
class CPUGPUInfo {
  CPUGPUInfo({
    required this.cpu,
    required this.gpu,
  });

  List<SingleCPUInfo> cpu;
  List<int> gpu;

  factory CPUGPUInfo.fromJson(Map<String, dynamic> json) => _$CPUGPUInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CPUGPUInfoToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}

// {
//     "scaling_cur_freq": 748800,
//     "scaling_min_freq": 556800,
//     "scaling_max_freq": 2745600
// },

@JsonSerializable()
class SingleCPUInfo {
  SingleCPUInfo({
    required this.scalingCurFreq,
    required this.scalingMinFreq,
    required this.scalingMaxFreq,
  });

  @JsonKey(name: 'scaling_cur_freq')
  int scalingCurFreq;
  @JsonKey(name: 'scaling_min_freq')
  int scalingMinFreq;
  @JsonKey(name: 'scaling_max_freq')
  int scalingMaxFreq;

  factory SingleCPUInfo.fromJson(Map<String, dynamic> json) => _$SingleCPUInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SingleCPUInfoToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}
