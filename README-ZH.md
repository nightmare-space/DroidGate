# DroidGate

[![](https://jitpack.io/v/nightmare-space/DroidGate.svg)](https://jitpack.io/#nightmare-space/DroidGate)

DroidGate 是一个轻量、插件化的 Android Framework API HTTP 网关。它既可以运行在 Android 应用内部，也可以通过 `adb shell app_process` 作为独立 dex 进程启动。

本仓库只包含公开的基础能力和少量示例插件，用于展示 DroidGate 的插件模型，以及插件如何通过编译期桩代码调用 Android 隐藏 API。

## 公开模块

- `droidgate-core`：HTTP 服务、运行时上下文和插件基础。
- `droidgate-hidden-api`：公开示例需要的最小隐藏 API 编译桩，这些类不会被打包进 dex server。
- `droidgate-plugins`：Activity 管理、编解码器查询和设备信息三个示例插件。
- `droidgate-bundle`：注册三个公开示例插件并提供统一启动入口。

## 公开示例接口

| 路由 | 用途 |
| --- | --- |
| `/activity_manager` | 通过隐藏 Binder API 启动或停止 Activity，以及移除任务。 |
| `/codec` | 通过公开 Android Framework API 查询编解码器。 |
| `/device_info` | 从 procfs 和 sysfs 读取示例 CPU、GPU 信息。 |

除 `/check` 外，请求必须通过 Header 或查询参数携带 `key`。服务会采用第一次有效请求提供的 key，后续请求必须使用相同的 key。

## 架构

![](docs/applib.excalidraw.svg)

客户端只需要知道服务地址、端口和请求 key，可以使用任何能够发送 HTTP 请求的语言编写。

## Dex Mode

Dex Mode 以 Android shell 用户运行 DroidGate，适合开发调试，以及调用普通应用进程无法访问、但 `adb shell` 可以访问的 API。

环境要求：

- Java 17
- Android SDK Platform 35
- Android Build Tools 36.1.0
- 已通过 `adb` 连接 Android 设备
- 已配置 `ANDROID_HOME`

在默认设备上构建并启动 DroidGate：

```bash
./scripts/build_and_run.sh
```

通过序列号指定设备：

```bash
./scripts/build_and_run.sh DEVICE_SERIAL
```

脚本会编译公开 Java 源码，生成 `scripts/build/droidgate-server`，将其推送至 `/data/local/tmp`，转发 TCP 端口 `15000`，然后通过 `app_process` 启动。

手动构建时可以覆盖 Platform 和 Build Tools 版本：

```bash
ANDROID_PLATFORM=35 ANDROID_BUILD_TOOLS=36.1.0 ./scripts/build_without_gradle.sh
```

检查服务是否可访问：

```bash
curl http://127.0.0.1:15000/check
```

调用示例接口：

```bash
curl -H 'key: demo' 'http://127.0.0.1:15000/codec?action=get_codec_list'
```

## Activity Mode

使用仓库 Tag 作为版本号添加 bundle 依赖：

```gradle
implementation 'com.github.nightmare-space.DroidGate:droidgate-bundle:v1.0.0'
```

通过 Android `Context` 启动服务：

```java
int port = DroidGate.startServerFromActivity(context);
```

Activity Mode 使用宿主应用的 Context 和权限。宿主应用需要自行管理生命周期、权限及网络暴露范围。

## 开发插件

继承 `DroidGatePlugin`，声明路由并处理 NanoHTTPD session：

```java
public final class ExamplePlugin extends DroidGatePlugin {
    @Override
    public String route() {
        return "/example";
    }

    @Override
    public NanoHTTPD.Response handle(NanoHTTPD.IHTTPSession session) {
        return NanoHTTPD.newFixedLengthResponse("hello from DroidGate");
    }
}
```

可以将插件注册到 `DroidGateServer`，也可以基于公开的 `droidgate-bundle` 模块创建自己的 bundle。

隐藏 API 声明应放在 `droidgate-hidden-api` 中，并以 `compileOnly` 依赖使用。运行时的真实实现由 Android 系统提供。

## 构建 Android Library

```bash
./gradlew \
  :droidgate-hidden-api:assembleRelease \
  :droidgate-core:assembleRelease \
  :droidgate-plugins:assembleRelease \
  :droidgate-bundle:assembleRelease
```

公开仓库有意只保留最小示例发行版本。
