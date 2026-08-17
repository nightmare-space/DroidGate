// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfos _$UserInfosFromJson(Map<String, dynamic> json) => UserInfos(
  success: json['success'] as bool,
  action: json['action'] as String,
  excludePartial: json['exclude_partial'] as bool,
  excludeDying: json['exclude_dying'] as bool,
  excludePreCreated: json['exclude_pre_created'] as bool,
  count: (json['count'] as num).toInt(),
  users: (json['users'] as List<dynamic>)
      .map((e) => UserInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UserInfosToJson(UserInfos instance) => <String, dynamic>{
  'success': instance.success,
  'action': instance.action,
  'exclude_partial': instance.excludePartial,
  'exclude_dying': instance.excludeDying,
  'exclude_pre_created': instance.excludePreCreated,
  'count': instance.count,
  'users': instance.users,
};

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  flags: (json['flags'] as num).toInt(),
  userType: json['user_type'] as String,
  serialNumber: (json['serial_number'] as num).toInt(),
  profileGroupId: (json['profile_group_id'] as num).toInt(),
  partial: json['partial'] as bool,
  preCreated: json['pre_created'] as bool,
  running: json['running'] as bool,
);

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'flags': instance.flags,
  'user_type': instance.userType,
  'serial_number': instance.serialNumber,
  'profile_group_id': instance.profileGroupId,
  'partial': instance.partial,
  'pre_created': instance.preCreated,
  'running': instance.running,
};

RemoveProfileResult _$RemoveProfileResultFromJson(Map<String, dynamic> json) =>
    RemoveProfileResult(
      action: json['action'] as String,
      userId: (json['user_id'] as num).toInt(),
      mode: json['mode'] as String,
      userBeforeRemoval: UserInfo.fromJson(
        json['user_before_removal'] as Map<String, dynamic>,
      ),
      binderResult: json['binder_result'] as bool,
      accepted: json['accepted'] as bool,
      wait: json['wait'] as bool,
      removed: json['removed'] as bool,
      success: json['success'] as bool,
    );

Map<String, dynamic> _$RemoveProfileResultToJson(
  RemoveProfileResult instance,
) => <String, dynamic>{
  'action': instance.action,
  'user_id': instance.userId,
  'mode': instance.mode,
  'user_before_removal': instance.userBeforeRemoval,
  'binder_result': instance.binderResult,
  'accepted': instance.accepted,
  'wait': instance.wait,
  'removed': instance.removed,
  'success': instance.success,
};

StartOrStopProfileResult _$StartOrStopProfileResultFromJson(
  Map<String, dynamic> json,
) => StartOrStopProfileResult(
  success: json['success'] as bool,
  action: json['action'] as String,
  userId: (json['user_id'] as num).toInt(),
  binderResult: json['binder_result'] as bool,
  user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StartOrStopProfileResultToJson(
  StartOrStopProfileResult instance,
) => <String, dynamic>{
  'success': instance.success,
  'action': instance.action,
  'user_id': instance.userId,
  'binder_result': instance.binderResult,
  'user': instance.user,
};

InstallExistingPackageResult _$InstallExistingPackageResultFromJson(
  Map<String, dynamic> json,
) => InstallExistingPackageResult(
  success: json['success'] as bool,
  action: json['action'] as String,
  packageName: json['package_name'] as String,
  userId: (json['user_id'] as num).toInt(),
  result: (json['result'] as num).toInt(),
);

Map<String, dynamic> _$InstallExistingPackageResultToJson(
  InstallExistingPackageResult instance,
) => <String, dynamic>{
  'success': instance.success,
  'action': instance.action,
  'package_name': instance.packageName,
  'user_id': instance.userId,
  'result': instance.result,
};
