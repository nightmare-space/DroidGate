import 'package:json_annotation/json_annotation.dart';
part 'app_info.g.dart';

@JsonSerializable()
class AppInfos {
  const AppInfos({required this.infos});

  @JsonKey(name: 'datas')
  final List<AppInfo> infos;

  factory AppInfos.fromJson(Map<String, dynamic> json) => _$AppInfosFromJson(json);
  Map<String, dynamic> toJson() => _$AppInfosToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class AppInfo {
  AppInfo({
    required this.package,
    required this.label,
    this.minSdk = 0,
    this.targetSdk = 0,
    this.versionName = '',
    this.versionCode = 0,
    this.enabled = false,
    this.hide = false,
    this.uid = 0,
    this.sourceDir = '',
    this.isSuspended = false,
    this.isInstalled = true,
    this.userId = 0,
  });
  String package;
  String label;
  String get appName => label;
  int minSdk;
  int targetSdk;
  String versionName;
  int versionCode;
  bool enabled;
  bool hide;
  int uid;
  int userId;
  String sourceDir;
  @JsonKey(name: 'is_suspend')
  bool isSuspended;
  @JsonKey(name: 'is_install')
  bool isInstalled;

  factory AppInfo.fromJson(Map<String, dynamic> json) => _$AppInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AppInfoToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}
