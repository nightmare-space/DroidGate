// {
//     "firstInstallTime": 1727310383763,
//     "lastUpdateTime": 1729941630827,
//     "dataDir": "/data/user/0/com.nightmare.remote",
//     "nativeLibraryDir": "/data/app/~~PXvsLmEZl5Us3Jo3a2wGrA==/com.nightmare.remote-rJDRd0AmNhq8jKWwnXQeCA==/lib/arm64"
// }
import 'package:json_annotation/json_annotation.dart';
part 'app_detail.g.dart';

@JsonSerializable()
class AppDetail {
  AppDetail({
    required this.firstInstallTime,
    required this.lastUpdateTime,
    required this.dataDir,
    required this.nativeLibraryDir,
    required this.apkSize,
    required this.md5,
    required this.sha1,
    required this.sha256,
  });

  @JsonKey(name: 'first_install_time')
  int firstInstallTime;
  @JsonKey(name: 'last_update_time')
  int lastUpdateTime;
  @JsonKey(name: 'data_dir')
  String dataDir;
  @JsonKey(name: 'native_library_dir')
  String nativeLibraryDir;
  @JsonKey(name: 'apk_size')
  int apkSize;
  String md5;
  String sha1;
  String sha256;

  factory AppDetail.fromJson(Map<String, dynamic> json) => _$AppDetailFromJson(json);
  Map<String, dynamic> toJson() => _$AppDetailToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}
