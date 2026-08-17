// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'droidgate_api.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main

class _DroidGateApi implements DroidGateApi {
  _DroidGateApi(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<String> check({RequestOptions? options}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/check',
    )..data = _data;
    final _result = await _dio.fetch<String>(_options);
    late String _value;
    try {
      _value = _result.data!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AppInfos> getAllAppInfos({
    RequestOptions? options,
    String? key,
    String action = 'get_all_app_info',
    bool? isSystemApp,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'is_system_app': isSystemApp,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/package_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AppInfos _value;
    try {
      _value = AppInfos.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AppDetail> getAppDetail({
    RequestOptions? options,
    String? key,
    String action = 'get_app_details',
    String? package,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'package': package,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/package_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AppDetail _value;
    try {
      _value = AppDetail.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AppMainActivity> getAppMainActivity({
    RequestOptions? options,
    String? key,
    String action = 'app_main_activity',
    String? package,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'package': package,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/package_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AppMainActivity _value;
    try {
      _value = AppMainActivity.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AppActivitys> getAppActivity({
    RequestOptions? options,
    String? key,
    String action = 'get_app_activities',
    String? package,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'package': package,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/package_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AppActivitys _value;
    try {
      _value = AppActivitys.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AppPermissions> getAppPermissions({
    RequestOptions? options,
    String? key,
    String action = 'get_permissions',
    String? package,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'package': package,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/package_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AppPermissions _value;
    try {
      _value = AppPermissions.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<PMResult> execPMCommand({
    RequestOptions? options,
    String? key,
    String action = 'pm_cmd',
    String? cmd,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action, r'cmd': cmd};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/package_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PMResult _value;
    try {
      _value = PMResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AppFlags> getAppFlags({
    RequestOptions? options,
    String? key,
    String action = 'get_app_flags',
    bool? private,
    String? package,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'private': private,
      r'package': package,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/package_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AppFlags _value;
    try {
      _value = AppFlags.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<int>> getAppIcon({
    RequestOptions? options,
    String? key,
    String action = 'get_icon',
    String? package,
    String? path,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'package': package,
      r'path': path,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      responseType: ResponseType.bytes,
      queryParameters: queryParameters,
      path: '/package_manager',
    )..data = _data;
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<int> _value;
    try {
      _value = _result.data!.cast<int>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DefaultResult> startActivity({
    RequestOptions? options,
    String? key,
    String action = 'start_activity',
    String? package,
    String? activity,
    String? displayId,
    int? userId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'package': package,
      r'activity': activity,
      r'displayId': displayId,
      r'userId': userId,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/activity_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DefaultResult _value;
    try {
      _value = DefaultResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<String> stopActivity({
    RequestOptions? options,
    String? key,
    String? package,
    String action = "stop_activity",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'package': package,
      r'action': action,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/activity_manager',
    )..data = _data;
    final _result = await _dio.fetch<String>(_options);
    late String _value;
    try {
      _value = _result.data!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Tasks> getTasks({
    RequestOptions? options,
    String? key,
    String action = 'get_tasks',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/activity_task_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Tasks _value;
    try {
      _value = Tasks.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AndroidProcesses> getAndroidProcess({
    RequestOptions? options,
    String? key,
    String action = 'get_running_apps',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/activity_task_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AndroidProcesses _value;
    try {
      _value = AndroidProcesses.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DefaultResult> setFocusedTask({
    RequestOptions? options,
    String? key,
    String action = 'set_focused_task',
    required int id,
    int displayId = 0,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'id': id,
      r'display_id': displayId,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/activity_task_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DefaultResult _value;
    try {
      _value = DefaultResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<int>> getTaskSnapshot({
    RequestOptions? options,
    String? key,
    String action = 'get_task_snapshot',
    required int id,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action, r'id': id};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      responseType: ResponseType.bytes,
      queryParameters: queryParameters,
      path: '/activity_task_manager',
    )..data = _data;
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<int> _value;
    try {
      _value = _result.data!.cast<int>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> moveTask({
    RequestOptions? options,
    String? key,
    String action = 'move_task',
    required int id,
    required int displayId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'id': id,
      r'display_id': displayId,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/activity_task_manager',
    )..data = _data;
    await _dio.fetch<void>(_options);
  }

  @override
  Future<DefaultResult> removeTask({
    RequestOptions? options,
    required int id,
    required String key,
    String action = "remove_task",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'id': id, r'action': action};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/activity_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DefaultResult _value;
    try {
      _value = DefaultResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Displays> display({
    RequestOptions? options,
    String? key,
    String action = "getDisplays",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/display_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Displays _value;
    try {
      _value = Displays.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Display> createVirtualDisplay({
    RequestOptions? options,
    String? key,
    required String width,
    required String height,
    required String density,
    bool? useDeviceConfig,
    String? displayName,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'width': width,
      r'height': height,
      r'density': density,
      r'useDeviceConfig': useDeviceConfig,
      r'displayName': displayName,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'POST',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/display_manager?action=createVirtualDisplay',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Display _value;
    try {
      _value = Display.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CPUGPUInfo> getCpuGpuInfo({
    RequestOptions? options,
    String? key,
    String action = "cpu_gpu_info",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/device_info',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CPUGPUInfo _value;
    try {
      _value = CPUGPUInfo.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<String> getProcStat({
    RequestOptions? options,
    String? key,
    String action = "proc_stat",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/device_info',
    )..data = _data;
    final _result = await _dio.fetch<String>(_options);
    late String _value;
    try {
      _value = _result.data!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<InputDevices> getInputDevices({
    RequestOptions? options,
    String? key,
    String action = "get_input_devices",
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/input_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late InputDevices _value;
    try {
      _value = InputDevices.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DefaultResult> bindDeviceToDisplay({
    RequestOptions? options,
    String? key,
    String action = "bind_device_to_display",
    required String descriptor,
    required String display,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'descriptor': descriptor,
      r'display': display,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/input_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DefaultResult _value;
    try {
      _value = DefaultResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DefaultResult> moveImeToDisplay({
    RequestOptions? options,
    String? key,
    String action = 'move_ime_to_display',
    required int displayId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'display': displayId,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/input_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DefaultResult _value;
    try {
      _value = DefaultResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DefaultResult> removeInputDevice({
    RequestOptions? options,
    String? key,
    String action = 'remove_device',
    required String descriptor,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'descriptor': descriptor,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/input_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DefaultResult _value;
    try {
      _value = DefaultResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DefaultListResult> getCodecList({
    RequestOptions? options,
    String? key,
    String action = 'get_codec_list',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/codec',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DefaultListResult _value;
    try {
      _value = DefaultListResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<NotificationInfo>> getNotifications({
    RequestOptions? options,
    String? key,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/notification_manager',
    )..data = _data;
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<NotificationInfo> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) => NotificationInfo.fromJson(i as Map<String, dynamic>),
          )
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<String> getFileHome({
    RequestOptions? options,
    String? key,
    String action = 'home',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/file',
    )..data = _data;
    final _result = await _dio.fetch<String>(_options);
    late String _value;
    try {
      _value = _result.data!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<FileInfos> getDirectory({
    RequestOptions? options,
    String? key,
    String action = 'dir',
    required String path,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action, r'path': path};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/file',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late FileInfos _value;
    try {
      _value = FileInfos.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<int>> downloadFile({
    RequestOptions? options,
    String? key,
    String action = 'file',
    required String path,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action, r'path': path};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      responseType: ResponseType.bytes,
      queryParameters: queryParameters,
      path: '/file',
    )..data = _data;
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<int> _value;
    try {
      _value = _result.data!.cast<int>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<String> deleteFile({
    RequestOptions? options,
    String? key,
    String action = 'delete',
    required String path,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action, r'path': path};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/file',
    )..data = _data;
    final _result = await _dio.fetch<String>(_options);
    late String _value;
    try {
      _value = _result.data!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<String> renameFile({
    RequestOptions? options,
    String? key,
    String action = 'rename',
    required String path,
    required String name,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'path': path,
      r'name': name,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/file',
    )..data = _data;
    final _result = await _dio.fetch<String>(_options);
    late String _value;
    try {
      _value = _result.data!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<String> getFileToken({
    RequestOptions? options,
    String? key,
    String action = 'token',
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/file',
    )..data = _data;
    final _result = await _dio.fetch<String>(_options);
    late String _value;
    try {
      _value = _result.data!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<String> uploadFile({
    RequestOptions? options,
    String? key,
    String action = 'upload',
    required String fileName,
    required String path,
    required List<int> bytes,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Content-Type': 'application/octet-stream',
      r'key': key,
      r'filename': fileName,
      r'path': path,
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = bytes;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'POST',
      contentType: 'application/octet-stream',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/file',
    )..data = _data;
    final _result = await _dio.fetch<String>(_options);
    late String _value;
    try {
      _value = _result.data!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<String> getFileMd5({
    RequestOptions? options,
    String? key,
    String action = 'md5',
    required String path,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'action': action, r'path': path};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/file',
    )..data = _data;
    final _result = await _dio.fetch<String>(_options);
    late String _value;
    try {
      _value = _result.data!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<UserInfo> getUser({
    RequestOptions? options,
    String? key,
    String action = 'get_user',
    required int userId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'user_id': userId,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/user_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UserInfo _value;
    try {
      _value = UserInfo.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<UserInfos> getUsers({
    RequestOptions? options,
    String? key,
    String action = 'get_users',
    bool? excludePartial,
    bool? excludeDying,
    bool? excludePreCreated,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'exclude_partial': excludePartial,
      r'exclude_dying': excludeDying,
      r'exclude_pre_created': excludePreCreated,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/user_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UserInfos _value;
    try {
      _value = UserInfos.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<UserInfo> createUser({
    RequestOptions? options,
    String? key,
    String action = 'create_user',
    required String name,
    String? userType,
    String? flags,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'name': name,
      r'user_type': userType,
      r'flags': flags,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/user_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UserInfo _value;
    try {
      _value = UserInfo.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<UserInfo> createProfile({
    RequestOptions? options,
    String? key,
    String action = 'create_profile',
    required String name,
    String? userType,
    String? flags,
    required int parentUserId,
    String? disallowedPackages,
    bool? evenWhenDisallowed,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'name': name,
      r'user_type': userType,
      r'flags': flags,
      r'parent_user_id': parentUserId,
      r'disallowed_packages': disallowedPackages,
      r'even_when_disallowed': evenWhenDisallowed,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/user_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UserInfo _value;
    try {
      _value = UserInfo.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<UserInfo> preCreateUser({
    RequestOptions? options,
    String? key,
    String action = 'pre_create_user',
    required String userType,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'user_type': userType,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/user_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UserInfo _value;
    try {
      _value = UserInfo.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<RemoveProfileResult> removeProfile({
    RequestOptions? options,
    String? key,
    String action = 'remove_profile',
    required int userId,
    required int confirmUserId,
    String? mode,
    bool? wait,
    int? timeoutMs,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'user_id': userId,
      r'confirm_user_id': confirmUserId,
      r'mode': mode,
      r'wait': wait,
      r'timeout_ms': timeoutMs,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/user_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RemoveProfileResult _value;
    try {
      _value = RemoveProfileResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<StartOrStopProfileResult> startProfile({
    RequestOptions? options,
    String? key,
    String action = 'start_profile',
    required int userId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'user_id': userId,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/user_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StartOrStopProfileResult _value;
    try {
      _value = StartOrStopProfileResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<StartOrStopProfileResult> stopProfile({
    RequestOptions? options,
    String? key,
    String action = 'stop_profile',
    required int userId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'user_id': userId,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/user_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StartOrStopProfileResult _value;
    try {
      _value = StartOrStopProfileResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<InstallExistingPackageResult> installExistingPackage({
    RequestOptions? options,
    String? key,
    String action = 'install_existing_package',
    required String packageName,
    required int userId,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'action': action,
      r'package_name': packageName,
      r'user_id': userId,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'key': key};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '/user_manager',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late InstallExistingPackageResult _value;
    try {
      _value = InstallExistingPackageResult.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  RequestOptions newRequestOptions(Object? options) {
    if (options is RequestOptions) {
      return options;
    }
    if (options is Options) {
      return RequestOptions(
        method: options.method,
        sendTimeout: options.sendTimeout,
        receiveTimeout: options.receiveTimeout,
        extra: options.extra,
        headers: options.headers,
        responseType: options.responseType,
        contentType: options.contentType.toString(),
        validateStatus: options.validateStatus,
        receiveDataWhenStatusError: options.receiveDataWhenStatusError,
        followRedirects: options.followRedirects,
        maxRedirects: options.maxRedirects,
        requestEncoder: options.requestEncoder,
        responseDecoder: options.responseDecoder,
        path: '',
      );
    }
    return RequestOptions(path: '');
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
