// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AndroidProcesses _$AndroidProcessesFromJson(Map<String, dynamic> json) =>
    AndroidProcesses(
      datas: (json['datas'] as List<dynamic>)
          .map((e) => AndroidProcess.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AndroidProcessesToJson(AndroidProcesses instance) =>
    <String, dynamic>{'datas': instance.datas};

AndroidProcess _$AndroidProcessFromJson(Map<String, dynamic> json) =>
    AndroidProcess(
      processName: json['processName'] as String,
      importance: (json['importance'] as num).toInt(),
      importanceReasonCode: (json['importanceReasonCode'] as num).toInt(),
      importanceReasonPid: (json['importanceReasonPid'] as num).toInt(),
      lru: (json['lru'] as num).toInt(),
      pid: (json['pid'] as num).toInt(),
      uid: (json['uid'] as num).toInt(),
    );

Map<String, dynamic> _$AndroidProcessToJson(AndroidProcess instance) =>
    <String, dynamic>{
      'processName': instance.processName,
      'importance': instance.importance,
      'importanceReasonCode': instance.importanceReasonCode,
      'importanceReasonPid': instance.importanceReasonPid,
      'lru': instance.lru,
      'pid': instance.pid,
      'uid': instance.uid,
    };
