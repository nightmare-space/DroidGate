// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationInfo _$NotificationInfoFromJson(Map<String, dynamic> json) =>
    NotificationInfo(
      package: json['package'] as String,
      appName: json['appName'] as String,
      id: (json['id'] as num).toInt(),
      tag: json['tag'] as String?,
      title: json['title'] as String,
      text: json['text'] as String,
      subText: json['subText'] as String?,
      bigText: json['bigText'] as String?,
      when: (json['when'] as num).toInt(),
      ongoing: json['ongoing'] as bool,
      clearable: json['clearable'] as bool,
    );

Map<String, dynamic> _$NotificationInfoToJson(NotificationInfo instance) =>
    <String, dynamic>{
      'package': instance.package,
      'appName': instance.appName,
      'id': instance.id,
      'tag': instance.tag,
      'title': instance.title,
      'text': instance.text,
      'subText': instance.subText,
      'bigText': instance.bigText,
      'when': instance.when,
      'ongoing': instance.ongoing,
      'clearable': instance.clearable,
    };
