// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppInfos _$AppInfosFromJson(Map<String, dynamic> json) => AppInfos(
  infos: (json['datas'] as List<dynamic>)
      .map((e) => AppInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AppInfosToJson(AppInfos instance) => <String, dynamic>{
  'datas': instance.infos,
};

AppInfo _$AppInfoFromJson(Map<String, dynamic> json) => AppInfo(
  package: json['package'] as String,
  label: json['label'] as String,
  minSdk: (json['minSdk'] as num?)?.toInt() ?? 0,
  targetSdk: (json['targetSdk'] as num?)?.toInt() ?? 0,
  versionName: json['versionName'] as String? ?? '',
  versionCode: (json['versionCode'] as num?)?.toInt() ?? 0,
  enabled: json['enabled'] as bool? ?? false,
  hide: json['hide'] as bool? ?? false,
  uid: (json['uid'] as num?)?.toInt() ?? 0,
  sourceDir: json['sourceDir'] as String? ?? '',
  isSuspended: json['is_suspend'] as bool? ?? false,
  isInstalled: json['is_install'] as bool? ?? true,
  userId: (json['userId'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AppInfoToJson(AppInfo instance) => <String, dynamic>{
  'package': instance.package,
  'label': instance.label,
  'minSdk': instance.minSdk,
  'targetSdk': instance.targetSdk,
  'versionName': instance.versionName,
  'versionCode': instance.versionCode,
  'enabled': instance.enabled,
  'hide': instance.hide,
  'uid': instance.uid,
  'userId': instance.userId,
  'sourceDir': instance.sourceDir,
  'is_suspend': instance.isSuspended,
  'is_install': instance.isInstalled,
};
