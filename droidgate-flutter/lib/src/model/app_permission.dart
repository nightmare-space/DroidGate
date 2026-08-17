// {
//     "datas": [
//         {
//             "name": "android.permission.INTERNET",
//             "description": "Allows the app to create network sockets and use custom network protocols. The browser and other applications provide means to send data to the internet, so this permission is not required to send data to the internet."
//         },
//         {
//             "name": "android.permission.VIBRATE",
//             "description": "Allows the app to control the vibrator."
//         },
//         {
//             "name": "android.permission.READ_EXTERNAL_STORAGE",
//             "description": "Allows the app to read the contents of your shared storage."
//         },
//         {
//             "name": "android.permission.WRITE_EXTERNAL_STORAGE",
//             "description": "Allows the app to write the contents of your shared storage."
//         },
//         {
//             "name": "android.permission.MANAGE_EXTERNAL_STORAGE"
//         },
//         {
//             "name": "android.permission.QUERY_ALL_PACKAGES",
//             "description": "Allows an app to see all installed packages."
//         },
//         {
//             "name": "android.permission.SYSTEM_ALERT_WINDOW",
//             "description": "This app can appear on top of other apps or other parts of the screen. This may interfere with normal app usage and change the way that other apps appear."
//         },
//         {
//             "name": "android.permission.NFC",
//             "description": "Allows the app to communicate with Near Field Communication (NFC) tags, cards, and readers."
//         },
//         {
//             "name": "android.permission.USB_PERMISSION"
//         },
//         {
//             "name": "android.permission.USE_BIOMETRIC",
//             "description": "Allows the app to use biometric hardware for authentication"
//         },
//         {
//             "name": "android.permission.USE_FINGERPRINT",
//             "description": "Allows the app to use fingerprint hardware for authentication"
//         },
//         {
//             "name": "android.permission.ACCESS_NETWORK_STATE",
//             "description": "Allows the app to view information about network connections such as which networks exist and are connected."
//         },
//         {
//             "name": "com.nightmare.remote.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION"
//         },
//         {
//             "name": "android.permission.CAMERA",
//             "description": "This app can take pictures and record videos using the camera while the app is in use."
//         }
//     ]
// }

import 'package:json_annotation/json_annotation.dart';
part 'app_permission.g.dart';
@JsonSerializable()
class AppPermissions {
  AppPermissions({
    required this.datas,
  });

  List<AppPermission> datas;

  factory AppPermissions.fromJson(Map<String, dynamic> json) => _$AppPermissionsFromJson(json);
  Map<String, dynamic> toJson() => _$AppPermissionsToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class AppPermission {
  AppPermission({
    required this.name,
    this.description,
  });

  String name;
  String? description;

  factory AppPermission.fromJson(Map<String, dynamic> json) => _$AppPermissionFromJson(json);
  Map<String, dynamic> toJson() => _$AppPermissionToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}