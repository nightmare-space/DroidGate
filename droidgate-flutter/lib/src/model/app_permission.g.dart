// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppPermissions _$AppPermissionsFromJson(Map<String, dynamic> json) =>
    AppPermissions(
      datas: (json['datas'] as List<dynamic>)
          .map((e) => AppPermission.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AppPermissionsToJson(AppPermissions instance) =>
    <String, dynamic>{'datas': instance.datas};

AppPermission _$AppPermissionFromJson(Map<String, dynamic> json) =>
    AppPermission(
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$AppPermissionToJson(AppPermission instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
