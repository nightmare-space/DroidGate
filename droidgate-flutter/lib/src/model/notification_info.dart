// {
//   "package": string,
//   "appName": string,
//   "id": int,
//   "tag": string(nullable),
//   "title": string,
//   "text": string,
//   "subText": string(nullable),
//   "bigText": string(nullable),
//   "when": int,
//   "ongoing": bool,
//   "clearable": bool
// }

import 'package:json_annotation/json_annotation.dart';
part 'notification_info.g.dart';

NotificationInfo deserializeNotificationInfo(Map<String, dynamic> json) => NotificationInfo.fromJson(json);
Map<String, dynamic> serializeNotificationInfo(NotificationInfo object) => object.toJson();

@JsonSerializable()
class NotificationInfo {
  NotificationInfo({
    required this.package,
    required this.appName,
    required this.id,
    required this.tag,
    required this.title,
    required this.text,
    required this.subText,
    required this.bigText,
    required this.when,
    required this.ongoing,
    required this.clearable,
  });

  String package;
  String appName;
  int id;
  String? tag;
  String title;
  String text;
  String? subText;
  String? bigText;
  int when;
  bool ongoing;
  bool clearable;

  factory NotificationInfo.fromJson(Map<String, dynamic> json) => _$NotificationInfoFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationInfoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
