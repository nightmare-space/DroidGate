// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cpu_gpu_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CPUGPUInfo _$CPUGPUInfoFromJson(Map<String, dynamic> json) => CPUGPUInfo(
  cpu: (json['cpu'] as List<dynamic>)
      .map((e) => SingleCPUInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  gpu: (json['gpu'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
);

Map<String, dynamic> _$CPUGPUInfoToJson(CPUGPUInfo instance) =>
    <String, dynamic>{'cpu': instance.cpu, 'gpu': instance.gpu};

SingleCPUInfo _$SingleCPUInfoFromJson(Map<String, dynamic> json) =>
    SingleCPUInfo(
      scalingCurFreq: (json['scaling_cur_freq'] as num).toInt(),
      scalingMinFreq: (json['scaling_min_freq'] as num).toInt(),
      scalingMaxFreq: (json['scaling_max_freq'] as num).toInt(),
    );

Map<String, dynamic> _$SingleCPUInfoToJson(SingleCPUInfo instance) =>
    <String, dynamic>{
      'scaling_cur_freq': instance.scalingCurFreq,
      'scaling_min_freq': instance.scalingMinFreq,
      'scaling_max_freq': instance.scalingMaxFreq,
    };
