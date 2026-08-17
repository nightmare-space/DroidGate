// {
//     "result": "Alarms\nAndroid\nAudiobooks\nDCIM\nDocuments\nDownload\nMovies\nMusic\nNotifications\nPictures\nPodcasts\nRecordings\nRingtones\napp_server_log\napp_servereee72788\nserver_port\n"
// }

import 'package:json_annotation/json_annotation.dart';
part 'cmd_result.g.dart';
@JsonSerializable()
class CmdResult {
  CmdResult({
    required this.result,
  });

  String result;

  factory CmdResult.fromJson(Map<String, dynamic> json) => _$CmdResultFromJson(json);
  Map<String, dynamic> toJson() => _$CmdResultToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}