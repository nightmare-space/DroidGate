// {
//     "activity": "com.nightmare.remote.MainActivity"
// }
import 'package:json_annotation/json_annotation.dart';
part 'app_main_activity.g.dart';
@JsonSerializable()
class AppMainActivity {
  AppMainActivity({
    required this.activity,
  });

  String activity;

  factory AppMainActivity.fromJson(Map<String, dynamic> json) => _$AppMainActivityFromJson(json);
  Map<String, dynamic> toJson() => _$AppMainActivityToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}