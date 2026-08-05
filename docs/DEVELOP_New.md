## 整体架构

DroidGate 是运行在 Android 设备上的系统能力网关。客户端只需要知道地址、端口和鉴权 key，不需要感知服务运行在哪种模式。

```text
Flutter / Web / Desktop / HTTP Client
                    |
                    | HTTP
                    v
                DroidGate
                    |
                    | plugin.route() 分发
                    v
Android Framework / Binder / Hidden APIs / Native
```

## 两种启动模式

### Embedded Mode

宿主 Android 应用提供真实 `Context`，DroidGate 使用 `14000–14039` 中的可用端口启动：

```java
int port = DroidGate.startServerFromActivity(context);
```

该模式受宿主应用权限约束。

### Shell Mode

手工构建脚本会生成 `scripts/build/droidgate-server`，随后可以通过 `app_process` 以 shell UID 运行：

```sh
app_process \
  -Djava.library.path=/data/local/tmp \
  -Djava.class.path=/data/local/tmp/droidgate-server \
  /system/bin \
  --nice-name=droidgate \
  com.nightmare.droidgate.DroidGate shell
```

Shell Mode 使用 `15000–15039` 中的可用端口，并通过 `FakeContext` 和兼容层访问系统服务。

## 调试

连接设备后运行：

```sh
scripts/build_and_run.sh
```

端口转发：

```sh
adb forward tcp:15000 tcp:15000
```

健康检查：

```sh
curl 'http://127.0.0.1:15000/check'
```

接口调用示例：

```sh
curl 'http://127.0.0.1:15000/activity_task_manager?action=get_tasks&key=droidgate'
```

实际服务可能选择 `15000–15039` 中的其他端口，最终端口会写入设备端的 `server_port` 文件。

## 相关资料

[app_process 使用](https://ljd1996.github.io/2019/11/11/app-process%E4%BD%BF%E7%94%A8/)
