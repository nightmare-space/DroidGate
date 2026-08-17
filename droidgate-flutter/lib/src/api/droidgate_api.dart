// ignore_for_file: non_constant_identifier_names
import 'package:droidgate_flutter/src/model/model.dart';
import 'package:droidgate_flutter/src/model/pm_result.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
part 'droidgate_api.g.dart';

const String _packageManager = '/package_manager';
const String _activityManager = '/activity_manager';
const String _activityTaskManager = '/activity_task_manager';
const String _displayManager = '/display_manager';
const String _inputManager = '/input_manager';
const String _userManager = '/user_manager';
const String _deviceInfo = '/device_info';
const String _notificationManager = '/notification_manager';
const String _file = '/file';
const String _codec = '/codec';

// params const

const String _action = 'action';
const String _key = 'key';

@RestApi(baseUrl: "", parser: Parser.JsonSerializable)
abstract class DroidGateApi {
  factory DroidGateApi(Dio dio, {String baseUrl}) = _DroidGateApi;

  @GET('/check')
  Future<String> check({@DioOptions() RequestOptions? options});

  /// 获取所有应用列表
  @GET(_packageManager)
  Future<AppInfos> getAllAppInfos({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'get_all_app_info',
    @Query("is_system_app") bool? isSystemApp,
  });

  /// 获取应用详情
  /// get app detail
  @GET(_packageManager)
  Future<AppDetail> getAppDetail({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'get_app_details',
    @Query('package') String? package,
  });

  /// 通过包名获取 MainActivity
  /// get main activity by package
  @GET(_packageManager)
  Future<AppMainActivity> getAppMainActivity({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'app_main_activity',
    @Query('package') String? package,
  });

  /// 通过包名获取 所有的 Activitys
  /// get all activitys by package
  @GET(_packageManager)
  Future<AppActivitys> getAppActivity({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'get_app_activities',
    @Query('package') String? package,
  });

  /// 通过包名获取所有的 Permission
  /// get all permissions by package
  @GET(_packageManager)
  Future<AppPermissions> getAppPermissions({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'get_permissions',
    @Query('package') String? package,
  });

  /// 执行 pm 命令
  /// exec pm command
  @GET(_packageManager)
  Future<PMResult> execPMCommand({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'pm_cmd',
    @Query("cmd") String? cmd,
  });

  /// 通过包名获取所有的 Flag
  /// get all flags by package
  @GET(_packageManager)
  Future<AppFlags> getAppFlags({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'get_app_flags',
    @Query("private") bool? private,
    @Query('package') String? package,
  });

  @DioResponseType(ResponseType.bytes)
  @GET(_packageManager)
  Future<List<int>> getAppIcon({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'get_icon',
    @Query('package') String? package,
    @Query("path") String? path,
  });

  /// 启动App
  /// open app by package
  @GET(_activityManager)
  Future<DefaultResult> startActivity({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'start_activity',
    @Query('package') String? package,
    @Query("activity") String? activity,
    @Query("displayId") String? displayId,
    @Query("userId") int? userId,
  });

  /// 停止App
  /// stop app by package
  @GET(_activityManager)
  Future<String> stopActivity({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query('package') String? package,
    @Query(_action) String action = "stop_activity",
  });

  @GET(_activityTaskManager)
  Future<Tasks> getTasks({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'get_tasks',
  });

  @GET(_activityTaskManager)
  Future<AndroidProcesses> getAndroidProcess({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'get_running_apps',
  });

  @GET(_activityTaskManager)
  Future<DefaultResult> setFocusedTask({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'set_focused_task',
    @Query("id") required int id,
    @Query("display_id") int displayId = 0,
  });

  @DioResponseType(ResponseType.bytes)
  @GET(_activityTaskManager)
  Future<List<int>> getTaskSnapshot({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'get_task_snapshot',
    @Query("id") required int id,
  });

  @GET(_activityTaskManager)
  Future<void> moveTask({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'move_task',
    @Query("id") required int id,
    @Query("display_id") required int displayId,
  });

  /// 停止App
  /// stop app by package
  @GET(_activityManager)
  Future<DefaultResult> removeTask({
    @DioOptions() RequestOptions? options,
    @Query("id") required int id,
    @Header(_key) required String key,
    @Query(_action) String action = "remove_task",
  });

  @GET(_displayManager)
  Future<Displays> display({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = "getDisplays",
  });

  @POST('$_displayManager?action=createVirtualDisplay')
  Future<Display> createVirtualDisplay({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query("width") required String width,
    @Query("height") required String height,
    @Query("density") required String density,
    @Query("useDeviceConfig") bool? useDeviceConfig,
    // displayName
    @Query("displayName") String? displayName,
  });

  @GET(_deviceInfo)
  Future<CPUGPUInfo> getCpuGpuInfo({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = "cpu_gpu_info",
  });

  // {{base}}/device_info?action=proc_stat&key={{key}}

  @GET(_deviceInfo)
  Future<String> getProcStat({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = "proc_stat",
  });

  // {{base}}/input_manager?action=get_input_devices
  @GET(_inputManager)
  Future<InputDevices> getInputDevices({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = "get_input_devices",
  });

  // {{base}}/input_manager?action=bind_device_to_display&descriptor=542f6cdee76a9e2201822037a98805831dc97520&display=local:21
  @GET(_inputManager)
  Future<DefaultResult> bindDeviceToDisplay({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = "bind_device_to_display",
    @Query("descriptor") required String descriptor,
    @Query("display") required String display,
  });

  @GET(_inputManager)
  Future<DefaultResult> moveImeToDisplay({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'move_ime_to_display',
    @Query("display") required int displayId,
  });

  @GET(_inputManager)
  Future<DefaultResult> removeInputDevice({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'remove_device',
    @Query("descriptor") required String descriptor,
  });

  @GET(_codec)
  Future<DefaultListResult> getCodecList({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'get_codec_list',
  });

  @GET(_notificationManager)
  Future<List<NotificationInfo>> getNotifications({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
  });

  // ======== File Route ========

  @GET(_file)
  Future<String> getFileHome({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'home',
  });

  @GET(_file)
  Future<FileInfos> getDirectory({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'dir',
    @Query("path") required String path,
  });

  @DioResponseType(ResponseType.bytes)
  @GET(_file)
  Future<List<int>> downloadFile({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'file',
    @Query("path") required String path,
  });

  @GET(_file)
  Future<String> deleteFile({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'delete',
    @Query("path") required String path,
  });

  @GET(_file)
  Future<String> renameFile({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'rename',
    @Query("path") required String path,
    @Query("name") required String name,
  });

  @GET(_file)
  Future<String> getFileToken({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'token',
  });

  @Headers(<String, dynamic>{'Content-Type': 'application/octet-stream'})
  @POST(_file)
  Future<String> uploadFile({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'upload',
    @Header("filename") required String fileName,
    @Header("path") required String path,
    @Body() required List<int> bytes,
  });

  @GET(_file)
  Future<String> getFileMd5({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'md5',
    @Query("path") required String path,
  });

  // ======== File Route ========

  // ======== User Manager Route ========

  @GET(_userManager)
  Future<UserInfo> getUser({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'get_user',
    @Query("user_id") required int userId,
  });

  @GET(_userManager)
  Future<UserInfos> getUsers({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'get_users',
    @Query("exclude_partial") bool? excludePartial,
    @Query("exclude_dying") bool? excludeDying,
    @Query("exclude_pre_created") bool? excludePreCreated,
  });

  @GET(_userManager)
  Future<UserInfo> createUser({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'create_user',
    @Query("name") required String name,
    @Query("user_type") String? userType,
    @Query("flags") String? flags,
  });

  @GET(_userManager)
  Future<UserInfo> createProfile({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'create_profile',
    @Query("name") required String name,
    @Query("user_type") String? userType,
    @Query("flags") String? flags,
    @Query("parent_user_id") required int parentUserId,
    @Query("disallowed_packages") String? disallowedPackages,
    @Query("even_when_disallowed") bool? evenWhenDisallowed,
  });

  @GET(_userManager)
  Future<UserInfo> preCreateUser({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'pre_create_user',
    @Query("user_type") required String userType,
  });

  @GET(_userManager)
  Future<RemoveProfileResult> removeProfile({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'remove_profile',
    @Query("user_id") required int userId,
    @Query("confirm_user_id") required int confirmUserId,
    @Query("mode") String? mode,
    @Query("wait") bool? wait,
    @Query("timeout_ms") int? timeoutMs,
  });

  // Use Map<String, Object?> can ignore return type
  @GET(_userManager)
  Future<StartOrStopProfileResult> startProfile({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'start_profile',
    @Query('user_id') required int userId,
  });

  @GET(_userManager)
  Future<StartOrStopProfileResult> stopProfile({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'stop_profile',
    @Query("user_id") required int userId,
  });

  @GET(_userManager)
  Future<InstallExistingPackageResult> installExistingPackage({
    @DioOptions() RequestOptions? options,
    @Header(_key) String? key,
    @Query(_action) String action = 'install_existing_package',
    @Query("package_name") required String packageName,
    @Query("user_id") required int userId,
  });

  // ======== User Manager Route ========
}
