# droidgate_flutter

DroidGate 的 Flutter 客户端与 Android 自动启动插件。

在 Android 上注册插件时，会在宿主应用进程内启动嵌入式 DroidGate 服务。Dart 侧通过统一的 HTTP API 访问应用、任务、显示、输入和设备等系统能力。

```dart
import 'package:droidgate_flutter/droidgate_flutter.dart';

final client = DroidGateClient();
final apps = await client.getAllAppInfos();
```

桌面端连接已经由 shell 模式启动的 DroidGate 时，可以显式指定端口：

```dart
final client = DroidGateClient(port: 15000);
```

示例工程位于 `example/`。

