// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileInfos _$FileInfosFromJson(Map<String, dynamic> json) => FileInfos(
  files: (json['files'] as List<dynamic>)
      .map((e) => FileInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FileInfosToJson(FileInfos instance) => <String, dynamic>{
  'files': instance.files,
};

FileInfo _$FileInfoFromJson(Map<String, dynamic> json) => FileInfo(
  path: json['path'] as String,
  permissions: json['permissions'] as String,
  size: (json['size'] as num).toInt(),
  modified: json['modified'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$FileInfoToJson(FileInfo instance) => <String, dynamic>{
  'path': instance.path,
  'permissions': instance.permissions,
  'size': instance.size,
  'modified': instance.modified,
  'type': instance.type,
};
