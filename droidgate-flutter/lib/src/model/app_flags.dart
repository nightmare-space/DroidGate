import 'package:json_annotation/json_annotation.dart';
part 'app_flags.g.dart';

@JsonSerializable()
class AppFlags {
  const AppFlags({required this.flags});

  @JsonKey(name: 'flags')
  final Map<String, bool> flags;

  bool isSuspended() {
    return flags[(1 << 30).toString()] ?? false;
  }

  factory AppFlags.fromJson(Map<String, dynamic> json) => _$AppFlagsFromJson(json);
  Map<String, dynamic> toJson() => _$AppFlagsToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}
