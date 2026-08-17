// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppDetail _$AppDetailFromJson(Map<String, dynamic> json) => AppDetail(
  firstInstallTime: (json['first_install_time'] as num).toInt(),
  lastUpdateTime: (json['last_update_time'] as num).toInt(),
  dataDir: json['data_dir'] as String,
  nativeLibraryDir: json['native_library_dir'] as String,
  apkSize: (json['apk_size'] as num).toInt(),
  md5: json['md5'] as String,
  sha1: json['sha1'] as String,
  sha256: json['sha256'] as String,
);

Map<String, dynamic> _$AppDetailToJson(AppDetail instance) => <String, dynamic>{
  'first_install_time': instance.firstInstallTime,
  'last_update_time': instance.lastUpdateTime,
  'data_dir': instance.dataDir,
  'native_library_dir': instance.nativeLibraryDir,
  'apk_size': instance.apkSize,
  'md5': instance.md5,
  'sha1': instance.sha1,
  'sha256': instance.sha256,
};
