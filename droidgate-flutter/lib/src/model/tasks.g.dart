// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tasks _$TasksFromJson(Map<String, dynamic> json) => Tasks(
  datas: (json['datas'] as List<dynamic>)
      .map((e) => Task.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TasksToJson(Tasks instance) => <String, dynamic>{
  'datas': instance.datas,
};

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  id: (json['id'] as num).toInt(),
  taskId: (json['taskId'] as num?)?.toInt(),
  stackId: (json['stackId'] as num?)?.toInt(),
  affiliatedTaskId: (json['affiliatedTaskId'] as num).toInt(),
  persistentId: (json['persistentId'] as num).toInt(),
  topPackage: json['topPackage'] as String,
  topActivity: json['topActivity'] as String,
  label: json['label'] as String,
  displayId: (json['displayId'] as num?)?.toInt(),
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'id': instance.id,
  'taskId': instance.taskId,
  'stackId': instance.stackId,
  'persistentId': instance.persistentId,
  'affiliatedTaskId': instance.affiliatedTaskId,
  'displayId': instance.displayId,
  'topPackage': instance.topPackage,
  'topActivity': instance.topActivity,
  'label': instance.label,
};
