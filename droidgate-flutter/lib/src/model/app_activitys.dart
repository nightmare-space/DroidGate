
// {
//     "package": "com.nightmare.remote",
//     "activitys": [
//         "com.nightmare.remote.MainActivity",
//         "com.termux.api.activities.TermuxAPIActivity",
//         "com.termux.api.activities.TermuxApiPermissionActivity",
//         "com.termux.api.apis.DialogAPI$DialogActivity",
//         "com.termux.api.apis.FingerprintAPI$FingerprintActivity",
//         "com.termux.api.apis.NfcAPI$NfcActivity",
//         "com.termux.api.apis.SAFAPI$SAFActivity",
//         "com.termux.api.apis.StorageGetAPI$StorageActivity",
//         "com.nightmare.uncon.render_v2.activity.UFSActivityV2",
//         "io.flutter.plugins.urllauncher.WebViewActivity",
//         "com.journeyapps.barcodescanner.CaptureActivity"
//     ]
// }
import 'package:json_annotation/json_annotation.dart';
part 'app_activitys.g.dart';

@JsonSerializable()
class AppActivitys{
  AppActivitys({
    required this.package,
    required this.activitys,
  });
  String package;
  List<String> activitys;
  factory AppActivitys.fromJson(Map<String, dynamic> json) => _$AppActivitysFromJson(json);
  Map<String, dynamic> toJson() => _$AppActivitysToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}