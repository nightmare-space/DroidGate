// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_activitys.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppActivitys _$AppActivitysFromJson(Map<String, dynamic> json) => AppActivitys(
  package: json['package'] as String,
  activitys: (json['activitys'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$AppActivitysToJson(AppActivitys instance) =>
    <String, dynamic>{
      'package': instance.package,
      'activitys': instance.activitys,
    };
