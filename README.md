
## DroidGate
[![](https://jitpack.io/v/nightmare-space/DroidGate.svg)](https://jitpack.io/#nightmare-space/DroidGate)

DroidGate is a lightweight, pluggable gateway to Android system capabilities. It exposes framework APIs, Binder services, hidden APIs, and native capabilities through a unified HTTP interface.

It supports upper-layer frameworks such as Web or Flutter or any other frameworks that cannot directly access Java.

For example, in Flutter, we almost need to use MethodChannel to access Android APIs.

After implementing with MethodChannel, it cannot support accessing Android's MethodChannel in Flutter Web.

DroidGate provides a ready-to-use [Flutter Plugin](https://github.com/nightmare-space/droidgate_flutter), or you can implement clients in any language according to [API.md](docs/API.md).

## Features

- RESTful: Get information related to Android APIs via HTTP protocol.
- Plugin support: Custom plugins can be supported with simple code.
- Built-in APIs: Various APIs to get Context and Services in Dex.
- Built-in plugins: Multiple plugins, such as getting the app list, app icons, creating virtual displays, etc.
- Flutter Plugin support: Just include the Flutter dependency, and DroidGate will start with the plugin registration. You only need to call the Dart API on the Flutter side.
- Multiple modes support: Supports Activity Mode and Dex Mode.
- Security: A simple authentication to prevent malicious calls from port scanning.

## Architecture Diagram

```text
调用端（PC / Flutter / Web / 任意 HTTP 客户端）                         目标设备进程（Android）
┌──────────────────────────────────────────────┐                  ┌──────────────────────────────────────────────┐
│ Client 层                                    │                  │ DroidGate 设备端进程（HTTP Server）                │
│  - DroidGateClient（Flutter 插件/自写客户端）      │                  │  - Activity Mode：集成到 App 里启动          │
│  - 仅感知：IP/Port + key                     │                  │  - Dex Mode：adb shell app_process 启动      │
│  - 调用 REST：/check /display_manager/...    │                  │  - 监听端口：NanoHTTPD                       │
└─────────────────────┬────────────────────────┘                  └───────────────────────┬──────────────────────┘
                      │                        HTTP 请求（带 key）                        │
                      │                 直连(同机) / adb forward(跨机)                    │
                      ├──────────────────────────────────────────────────────────────────►│
                      │                                                                   │
                      │                                                                   │ 路由分发（按 plugin.route 前缀匹配）
                      │                                                                   ▼
                      │                                            ┌──────────────────────────────────────────────┐
                      │                                            │ 插件层（Plugins，按模块拆分 Android 能力）   │
                      │                                            │  - DisplayManagerPlugin：枚举显示器/建VD等   │
                      │                                            │  - ActivityManagerPlugin / TaskManager...    │
                      │                                            │  - InputManagerPlugin：输入/按键/注入相关    │
                      │                                            │  - PackageManagerPlugin：应用信息/图标等     │
                      │                                            │  - FilePlugin / DeviceInfoPlugin / Codec...  │
                      │                                            └───────────────────────┬─────·─────────────────┘
                      │                                                                    │
                      │                                                                    │ 反射/Wrapper/FakeContext（Dex Mode 常用）
                      │                                                                    ▼
                      │                                             ┌─────────────────────────────────────────────┐
                      │                                             │ Android Framework/系统服务                  │
                      │                                             │  - DisplayManager / WindowManager           │
                      │                                             │  - Activity/Task 管理服务                   │
                      │                                             │  - Input/Package/File 等系统 API            │
                      │                                             └─────────────────────────────────────────────┘
PC 侧端口转发典型链路（Dex Mode）：
PC:Client  ──HTTP──>  localhost:PORT
                ▲
                │ adb forward tcp:PORT tcp:PORT
                │
Android:shell 2000 上的 DroidGate Dex 进程（监听 PORT）
```

![](docs/applib.excalidraw.svg)

For upper-layer applications, only the Address and Port are perceived, regardless of the running mode.

You can get Android information via HTTP from anywhere, on any device.

Since HTTP is not secure, DroidGate has built-in simple interface authentication to prevent malicious calls from port scanning.

## Getting Started

DroidGate has two running modes.

### Activity Mode

In this case, DroidGate has a real Activity Context. For getting the app list, it needs to request permissions like accessing APIs on Android itself.

But the benefit of Restful API is that you can get an app's icon with such code (Flutter):

```dart
DroidGateClient droidGateClient = DroidGateClient();
Image.network(droidGateClient.iconUrl('com.nightmare'))
```

DroidGateClient is multi-instance, and all APIs are encapsulated under DroidGateClient.

Multi-instance allows loading information from different devices on the same page, such as Uncon.

![Uncon](docs/uncon.png)

## Dex Mode

The development startup script is [build_and_run.sh](scripts/build_and_run.sh).

In this mode, Java is first compiled into class files, then converted into dex files by dx or d8 tools.

Run app_process via adb to start dex.

The benefit of this mode is that we can use more permissions, such as getting background task thumbnails, creating virtual displays (with Group).

All Java permissions are for shell (uid 2000), so you don't need to request permissions separately for getting the app list, creating virtual displays, etc.

We can start this service on a device connected to a PC, then access it through `adb forward` (port forwarding is included in `build_and_run.sh`).

Next, you still only need to get the app's icon like this:

```dart
DroidGateClient droidGateClient = DroidGateClient(port: port);
Image.network(droidGateClient.iconUrl('com.nightmare'))
```

You can also implement various APIs yourself to get features far beyond adb command line, such as icons, background app screenshots, which adb commands do not support.

### Using in Flutter

Provide `droidgate_client` to quickly enable this capability in Flutter App without manually starting the service. `DroidGate` starts with Flutter Plugin registration, and directly creating `DroidGateClient` will use the port started by Flutter Plugin.

```yaml
dependencies:
  droidgate_client:
    git: https://github.com/nightmare-space/droidgate_client
```

Then directly use the encapsulated Dart API:

```dart
DroidGateClient droidGateClient = DroidGateClient();
AppInfos infos = await droidGateClient.getAppInfos();
```

If you need to access the same interface on a PC, just change the port via Dex Mode:

```dart
DroidGateClient droidGateClient = DroidGateClient(port: 15000);
AppInfos infos = await droidGateClient.getAppInfos();
```

Suppose I currently have a Flutter interface displaying the app list like this:

<img src="docs/app_manager.jpg" alt="" width="33%" />

Now I want this interface to be displayed on a PC or in Web.

After starting Dex, I only need to change the port number:

```dart
DroidGateClient droidGateClient = DroidGateClient(port: Platform.isMacOS ? 15000 : null);
```

![Uncon](docs/app_manager_mac.png)

In fact, this mode is already widely used in Uncon, Speed Share, and ADB KIT.

The file manager, app list, task list, etc., are all the same code, only the port number is different.

### Using in Native Android

Include the corresponding dependency according to the repository's Tag version:

```gradle
implementation 'com.github.nightmare-space.DroidGate:droidgate-bundle:v1.0.0'
```

#### Start the service

```java
try {
    int port = DroidGate.startServerFromActivity(context);
    Log.d(TAG, "port -> " + port);
} catch (Exception e) {
    Log.d(TAG, "error -> " + e);
    e.printStackTrace();
}
```

## Example Code

The example code includes all API usage methods. The example code is the best way to understand DroidGate.

<img src="docs/screenshot/01.jpg" alt="" width="33%" /><img src="docs/screenshot/02.jpg" alt="" width="33%" /><img src="docs/screenshot/03.jpg" alt="" width="33%" />
<img src="docs/screenshot/04.jpg" alt="" width="33%" /><img src="docs/screenshot/05.jpg" alt="" width="33%" />

See the complete code in [Flutter Example](https://github.com/nightmare-space/droidgate_flutter/tree/main/example).

## Repository Introduction

- droidgate-core: The gateway runtime and plugin foundation, without built-in capability plugins.
- droidgate-hidden-api: Compile-time stubs for Android hidden APIs used by the core and plugins.
- droidgate-plugins: Built-in capability plugins such as package, task, display, input, file, and user management.
- droidgate-bundle: The ready-to-use distribution that registers the built-in plugins and provides the `DroidGate` entry point.

## Developing Custom Plugins
TODO

## Outlook
I always think Tencent's PerfDog is too expensive. Using DroidGate, I think it should be possible to write a new PerfDog to get frame rate android other information on Android.
Also, Scene, LibChecker, can be supported on PC or even Web using DroidGate.

## Who is using it?
- [Speed Share](https://github.com/nightmare-space/speed_share): `DroidGate` is integrated into Speed Share in `Activity Mode`, allowing Speed Share to get the app list on the Flutter side to select an app to send to other devices.
- [ADB KIT](https://github.com/nightmare-space/adb_kit): `DroidGate` exists in both Activity Mode and Dex Mode in ADB KIT. The former is similar to Speed Share, used when we need to install an already installed Apk on the connected device. After a device is successfully connected, ADB KIT starts Dex Mode's DroidGate via app_process to achieve functions that adb command line cannot directly implement, such as file viewing and preview.
- Uncon (closed source): Exists in both Activity Mode and Dex Mode, similar to ADB KIT. After starting Dex Mode's DroidGate, Uncon is used to load the tasks running on the target device.

### More Scenario Screenshots

<img src="docs/file_manager_android.jpg" alt="" width="50%" /><img src="docs/app_select.jpg" alt="" width="50%" />

<img src="docs/uncon_file_manager.png" alt="" width="50%" /><img src="docs/uncon_app_starter.png" alt="" width="50%" />
