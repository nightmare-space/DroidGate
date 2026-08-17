// [
//   [
//     "/sdcard/Android",
//     "rwx",
//     3452,
//     "25-01-01 00:00",
//     "directory"
//   ],
// ]

import 'package:json_annotation/json_annotation.dart';
part 'file_info.g.dart';

@JsonSerializable()
class FileInfos {
  final List<FileInfo> files;

  FileInfos({
    required this.files,
  });

  factory FileInfos.fromJson(Map<String, dynamic> json) => _$FileInfosFromJson(json);
  Map<String, dynamic> toJson() => _$FileInfosToJson(this);
}

@JsonSerializable()
class FileInfo {
  final String path;
  final String permissions;
  final int size;
  final String modified;
  final String type;

  FileInfo({
    required this.path,
    required this.permissions,
    required this.size,
    required this.modified,
    required this.type,
  });

  factory FileInfo.fromJson(Map<String, dynamic> json) => _$FileInfoFromJson(json);
  Map<String, dynamic> toJson() => _$FileInfoToJson(this);
}