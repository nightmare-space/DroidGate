# droidgate_flutter

Flutter client and Android bootstrap plugin for DroidGate.

On Android, plugin registration starts an embedded DroidGate server in the host application process. Dart code accesses application, task, display, input, and device capabilities through DroidGate's HTTP API.

```dart
import 'package:droidgate_flutter/droidgate_flutter.dart';

final client = DroidGateClient();
final apps = await client.getAllAppInfos();
```

To connect to a DroidGate shell process from a desktop application, provide its port explicitly:

```dart
final client = DroidGateClient(port: 15000);
```

See `example/` for a runnable Flutter application.
