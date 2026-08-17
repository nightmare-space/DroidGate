// {
//   "id": int,
//   "name": string,
//   "flags": int,
//   "user_type": string,
//   "serial_number": int,
//   "profile_group_id": int,
//   "partial": bool,
//   "pre_created": bool,
//   "running": bool
// }

// {
//   "success": true,
//   "action": "get_users",
//   "exclude_partial": true,
//   "exclude_dying": false,
//   "exclude_pre_created": true,
//   "count": 3,
//   "users": [
//     {
//       "id": 0,
//       "name": "机主",
//       "flags": 19475,
//       "user_type": "android.os.usertype.full.SYSTEM",
//       "serial_number": 0,
//       "profile_group_id": 0,
//       "partial": false,
//       "pre_created": false,
//       "running": true
//     },
//   ]
// }

import 'package:json_annotation/json_annotation.dart';
part 'user_info.g.dart';

@JsonSerializable()
class UserInfos {
  final bool success;
  final String action;
  @JsonKey(name: 'exclude_partial')
  final bool excludePartial;
  @JsonKey(name: 'exclude_dying')
  final bool excludeDying;
  @JsonKey(name: 'exclude_pre_created')
  final bool excludePreCreated;
  final int count;
  final List<UserInfo> users;

  UserInfos({
    required this.success,
    required this.action,
    required this.excludePartial,
    required this.excludeDying,
    required this.excludePreCreated,
    required this.count,
    required this.users,
  });

  factory UserInfos.fromJson(Map<String, dynamic> json) => _$UserInfosFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfosToJson(this);
}

@JsonSerializable()
class UserInfo {
  final int id;
  final String name;
  final int flags;
  @JsonKey(name: 'user_type')
  final String userType;
  @JsonKey(name: 'serial_number')
  final int serialNumber;
  @JsonKey(name: 'profile_group_id')
  final int profileGroupId;
  final bool partial;
  @JsonKey(name: 'pre_created')
  final bool preCreated;
  final bool running;

  UserInfo({
    required this.id,
    required this.name,
    required this.flags,
    required this.userType,
    required this.serialNumber,
    required this.profileGroupId,
    required this.partial,
    required this.preCreated,
    required this.running,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

// {
//   "action": "remove_profile",
//   "user_id": 997,
//   "mode": "normal",
//   "user_before_removal": {
//     "id": 997,
//     "name": "MultiApp",
//     "flags": 67112976,
//     "user_type": "android.os.usertype.profile.CLONE",
//     "serial_number": 1001,
//     "profile_group_id": 0,
//     "partial": false,
//     "pre_created": false
//   },
//   "binder_result": false,
//   "accepted": false,
//   "wait": false,
//   "removed": false,
//   "success": false
// }
@JsonSerializable()
class RemoveProfileResult {
  final String action;
  @JsonKey(name: 'user_id')
  final int userId;
  final String mode;
  @JsonKey(name: 'user_before_removal')
  final UserInfo userBeforeRemoval;
  @JsonKey(name: 'binder_result')
  final bool binderResult;
  final bool accepted;
  final bool wait;
  final bool removed;
  final bool success;

  RemoveProfileResult({
    required this.action,
    required this.userId,
    required this.mode,
    required this.userBeforeRemoval,
    required this.binderResult,
    required this.accepted,
    required this.wait,
    required this.removed,
    required this.success,
  });

  factory RemoveProfileResult.fromJson(Map<String, dynamic> json) => _$RemoveProfileResultFromJson(json);
  Map<String, dynamic> toJson() => _$RemoveProfileResultToJson(this);
}

// {
//   "success": false,
//   "action": "stop_profile",
//   "user_id": 999,
//   "binder_result": false,
//   "user": {
//     "id": 999,
//     "name": "MultiApp",
//     "flags": 67112976,
//     "user_type": "android.os.usertype.profile.CLONE",
//     "serial_number": 10,
//     "profile_group_id": 0,
//     "partial": false,
//     "pre_created": false
//   }
// }

@JsonSerializable()
class StartOrStopProfileResult {
  final bool success;
  final String action;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'binder_result')
  final bool binderResult;
  final UserInfo user;

  StartOrStopProfileResult({
    required this.success,
    required this.action,
    required this.userId,
    required this.binderResult,
    required this.user,
  });

  factory StartOrStopProfileResult.fromJson(Map<String, dynamic> json) => _$StartOrStopProfileResultFromJson(json);
  Map<String, dynamic> toJson() => _$StartOrStopProfileResultToJson(this);
}

// {
//   "success": true,
//   "action": "install_existing_package",
//   "package_name": "com.termux",
//   "user_id": 999,
//   "result": 1
// }

@JsonSerializable()
class InstallExistingPackageResult {
  final bool success;
  final String action;
  @JsonKey(name: 'package_name')
  final String packageName;
  @JsonKey(name: 'user_id')
  final int userId;
  final int result;

  InstallExistingPackageResult({
    required this.success,
    required this.action,
    required this.packageName,
    required this.userId,
    required this.result,
  });

  factory InstallExistingPackageResult.fromJson(Map<String, dynamic> json) => _$InstallExistingPackageResultFromJson(json);
  Map<String, dynamic> toJson() => _$InstallExistingPackageResultToJson(this);
}
