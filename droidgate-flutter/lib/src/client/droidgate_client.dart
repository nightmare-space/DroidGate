// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:droidgate_flutter/src/api/droidgate_api.dart';
import 'package:droidgate_flutter/src/model/model.dart';
import 'package:droidgate_flutter/src/model/pm_result.dart';
import 'package:dio/dio.dart';
import 'package:global_repository/global_repository_dart.dart';

// import 'package:flutter/foundation.dart';
// ignore: non_constant_identifier_names
final defaultDroidGate = DroidGateClient();

class DroidGateClient {
  DroidGateClient({this.port, this.url = 'http://127.0.0.1'}) {
    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      port ??= 0;
    }
    BaseOptions options = BaseOptions(
      receiveDataWhenStatusError: true,
      contentType: Headers.jsonContentType,
      headers: {'Accept': '*/*'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      validateStatus: (status) {
        return status != null && status >= 200 && status < 300;
      },
      followRedirects: true,
    );
    Dio dio = Dio(options);
    // dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (options, handler) {
    //       print(options.extra);
    //       print('');
    //       Log.v('>>>>>>>>HTTP LOG');
    //       Log.v('>>>>>>>>URI: ${options.uri}');
    //       Log.v('>>>>>>>>Method: ${options.method}');
    //       Log.v('>>>>>>>>Headers: ${options.headers}');
    //       JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    //       String prettyprint = encoder.convert(options.data);
    //       Log.v('>>>>>>>>Body: $prettyprint');
    //       Log.v('<<<<<<<<');
    //       print('');
    //       // log response
    //       handler.next(options);
    //     },
    //   ),
    // );
    port ??= getPort();
    baseUrl = '$url:$port';
    Log.i('DroidGateClient init port:$port');
    api = DroidGateApi(dio, baseUrl: baseUrl);
    genKey();
  }

  String baseUrl = '';

  String tag = '$DroidGateClient';

  int? port;

  String url;

  late DroidGateApi api;

  int? getPort() {
    String data = File('${RuntimeEnvir.filesPath}/server_port').readAsStringSync();
    return int.tryParse(data);
  }

  AppInfos userApps = const AppInfos(infos: []);
  AppInfos systemApps = const AppInfos(infos: []);

  // 起初 App Channel 本身不存储相关数据，只做通信
  // 但后面发现经常一个 App 中有多个 AppChannel(例如 ADB KIT)
  // 如果此时再将 Channel 对应设备的软件信息存在别的地方，例如 AppController
  // 数据就会非常的乱
  //
  // At first, the App Channel itself does not store related data, only communication
  // But later found that there are often multiple AppChannels in an App (such as ADB KIT)
  // If the software information of the device corresponding to the channel is stored elsewhere at this time, such as AppController
  // The data will be very messy
  Future<void> loadUserApps() async {
    userApps = await getAllAppInfos();
    userApps.infos.sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
  }

  Future<void> loadSystemApps() async {
    systemApps = await getAllAppInfos(isSystemApp: true);
    systemApps.infos.sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
  }

  String? apiKey;

  Completer<void> keyCompleter = Completer<void>();

  bool get release => const bool.fromEnvironment('dart.vm.product');

  Future<void> genKey() async {
    // TODO 储存上一次的key
    apiKey = !release ? 'droidgate' : () {}.hashCode.toString();
    apiKey = 'droidgate';
    keyCompleter.complete();
  }

  Future<void> waitKeyGen() async {
    await keyCompleter.future;
  }

  Future<AppInfos> getAllAppInfos({bool? isSystemApp}) async {
    return api.getAllAppInfos(key: apiKey, isSystemApp: isSystemApp);
  }

  Future<AppDetail> getAppDetails({required String package}) async {
    return api.getAppDetail(key: apiKey, package: package);
  }

  Future<AppActivitys> getAppActivitys({required String package}) async {
    return api.getAppActivity(key: apiKey, package: package);
  }

  Future<AppMainActivity> getAppMainActivity({required String package}) async {
    return api.getAppMainActivity(key: apiKey, package: package);
  }

  Future<String> getAppMainActivityString(String package) async {
    return (await api.getAppMainActivity(key: apiKey, package: package)).activity;
  }

  Future<AppPermissions> getAppPermission({required String package}) async {
    return api.getAppPermissions(key: apiKey, package: package);
  }

  Future<Displays> getDisplays() async {
    return api.display(key: apiKey);
  }

  Future<DefaultResult> startActivity({required String package, required String activity, int displayId = 0, int userId = 0}) async {
    return api.startActivity(key: apiKey, package: package, activity: activity, displayId: '$displayId', userId: userId);
  }

  Future<void> stopActivity({required String package}) async {
    api.stopActivity(key: apiKey, package: package);
  }

  Future<DefaultResult> removeTask({required int id}) async {
    return await api.removeTask(key: apiKey!, id: id);
  }

  Future<AppFlags> getAppFlags({required String package, bool? private}) async {
    return api.getAppFlags(key: apiKey, package: package, private: private);
  }

  Future<PMResult> execPMCommand(String command) async {
    return api.execPMCommand(key: apiKey, cmd: command);
  }

  /// file url
  /// {{base}}/file?action=file&path=/sdcard/test.sh&key={{key}}
  String fileUrl(String path) {
    if (!keyCompleter.isCompleted) {
      throw 'key not ready';
    }
    return '$baseUrl/file?action=file&path=$path&key=$apiKey';
  }

  String apkIconUrl({String? package, String? path}) {
    if (!keyCompleter.isCompleted) {
      throw 'key not ready';
    }
    if (path != null) {
      return '$baseUrl/package_manager?key=$apiKey&action=get_icon&path=$path';
    }
    return '$baseUrl/package_manager?key=$apiKey&action=get_icon&package=$package';
  }

  @Deprecated('use apkIconUrl instead')
  String iconUrl(String package) => apkIconUrl(package: package);

  String taskSnapshotUrl(int taskId) {
    if (!keyCompleter.isCompleted) {
      throw 'key not ready';
    }
    return '$baseUrl/activity_task_manager?action=get_task_snapshot&key=$apiKey&id=$taskId';
  }

  @Deprecated('use taskSnapshotUrl instead')
  String taskUrl(int taskId) => taskSnapshotUrl(taskId);

  Future<Tasks> getTasks() async {
    return api.getTasks(key: apiKey);
  }

  Future<DefaultResult> setFocusedTask(int id) async {
    return api.setFocusedTask(key: apiKey, id: id);
  }

  // Future<bool> clearAppData(String packageName) async {
  //   String result = await exec('pm clear $packageName');
  //   return result.isNotEmpty;
  // }

  // Future<bool> hideApp(String packageName) async {
  //   String result = await exec('pm hide $packageName');
  //   return result.isNotEmpty;
  // }

  // Future<bool> showApp(String packageName) async {
  //   String result = await exec('pm unhide $packageName');
  //   return result.isNotEmpty;
  // }

  // Future<bool> freezeApp(String packageName) async {
  //   Log.i('pm disable $packageName');
  //   String result = await exec(
  //     'pm disable-user --user 0 $packageName',
  //   );
  //   return result.isNotEmpty;
  // }

  // Future<bool> unFreezeApp(String packageName) async {
  //   String result = await exec('pm enable --user 0 $packageName');
  //   return result.isNotEmpty;
  // }

  // Future<bool> unInstallApp(String packageName) async {
  //   String result = await exec('pm uninstall  $packageName');
  //   return result.isNotEmpty;
  // }

  // Future<String> getFileSize(String path) async {
  //   return await exec('stat -c "%s" $path');
  // }

  Future<Display?> createVirtualDisplay({int? width, int? height, int? density, bool? useDeviceConfig, String? name = 'droidgate-vd'}) async {
    assert(width != null || height != null || density != null || useDeviceConfig != null, 'At least one parameter must be non-null');
    try {
      Display display = await api.createVirtualDisplay(
        key: apiKey,
        width: width.toString(),
        height: height.toString(),
        density: density.toString(),
        useDeviceConfig: useDeviceConfig,
        displayName: name,
      );
      return display;
    } on DioException catch (e) {
      Log.e('createVirtualDisplay Error -> ${e.message} ${e.error} ${e.response}');
      return null;
    }
  }

  Future<Display?> createVirtualDisplayWithSurfaceView({int? width, int? height, int? density, bool? useDeviceConfig, String? name = 'droidgate-vd'}) async {
    assert(width != null || height != null || density != null || useDeviceConfig != null, 'At least one parameter must be non-null');
    try {
      Display display = await api.createVirtualDisplay(
        key: apiKey,
        width: width.toString(),
        height: height.toString(),
        density: density.toString(),
        useDeviceConfig: useDeviceConfig,
        displayName: name,
      );
      return display;
    } on DioException catch (e) {
      Log.e('createVirtualDisplay Error -> ${e.message} ${e.error} ${e.response}');
      return null;
    }
  }

  Future<InputDevices> getInputDevices() async {
    return api.getInputDevices(key: apiKey);
  }

  Future<DefaultResult> bindDeviceToDisplay({String action = "bind_device_to_display", required String descriptor, required String display}) {
    return api.bindDeviceToDisplay(key: apiKey, action: action, descriptor: descriptor, display: display);
  }
}
