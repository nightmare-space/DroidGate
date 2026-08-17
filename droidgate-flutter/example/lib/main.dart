import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:droidgate_flutter/droidgate_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

const _examplePackageName = 'com.example.droidgate_flutter_example';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RuntimeEnvir.initEnvirWithPackageName(_examplePackageName);
  await Highlighter.initialize(['json']);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DroidGate Flutter Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(surface: const Color(0xfff3f4f9), surfaceContainer: const Color(0xffe8e9ee)),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DroidGateClient droidGateClient = DroidGateClient(port: Platform.isMacOS ? 15000 : null);

  late final Highlighter highlighter;
  late final List<_DemoRequest> requests;
  late final String iconUrl;
  bool ready = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    final theme = await HighlighterTheme.loadLightTheme();
    await droidGateClient.waitKeyGen();

    highlighter = Highlighter(language: 'json', theme: theme);
    iconUrl = droidGateClient.apkIconUrl(package: _examplePackageName);
    requests = [
      _DemoRequest(title: 'User applications', future: loadUserApplications()),
      _DemoRequest(title: 'System applications', future: loadSystemApplications()),
      _DemoRequest(
        title: 'Application details',
        future: droidGateClient.getAppDetails(package: _examplePackageName),
      ),
      _DemoRequest(
        title: 'Application activities',
        future: droidGateClient.getAppActivitys(package: _examplePackageName),
      ),
      _DemoRequest(
        title: 'Main activity',
        future: droidGateClient.getAppMainActivity(package: _examplePackageName),
      ),
      _DemoRequest(
        title: 'Permissions',
        future: droidGateClient.getAppPermission(package: _examplePackageName),
      ),
      _DemoRequest(
        title: 'Application flags',
        future: droidGateClient.getAppFlags(package: 'com.android.shell'),
      ),
      _DemoRequest(
        title: 'Private application flags',
        future: droidGateClient.getAppFlags(package: 'com.android.shell', private: true),
      ),
      _DemoRequest(title: 'Displays', future: droidGateClient.getDisplays()),
      _DemoRequest(title: 'Tasks', future: droidGateClient.getTasks()),
      _DemoRequest(
        title: 'Codec list',
        future: droidGateClient.api.getCodecList(key: droidGateClient.apiKey),
      ),
      _DemoRequest(
        title: 'Proc stat',
        future: droidGateClient.api.getProcStat(key: droidGateClient.apiKey),
      ),
    ];

    if (!mounted) {
      return;
    }
    setState(() {
      ready = true;
    });
  }

  Future<AppInfos> loadUserApplications() async {
    final applications = await droidGateClient.getAllAppInfos(isSystemApp: false);
    return AppInfos(infos: applications.infos.take(2).toList());
  }

  Future<AppInfos> loadSystemApplications() async {
    final applications = await droidGateClient.getAllAppInfos(isSystemApp: true);
    return AppInfos(infos: applications.infos.take(3).toList());
  }

  String formatResult(Object? data) {
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  String formatError(Object? error) {
    if (error is DioException && error.response?.data != null) {
      final data = error.response!.data;
      if (data is String) {
        try {
          return formatResult(jsonDecode(data));
        } catch (_) {
          return data;
        }
      }
      return formatResult(data);
    }
    return formatResult({'success': false, 'error': 'request_failed'});
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('DroidGate Flutter Example'),
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildServerCard(context),
          const SizedBox(height: 12),
          _buildIconCard(context),
          for (final request in requests) ...[const SizedBox(height: 12), _buildRequestCard(context, request)],
        ],
      ),
    );
  }

  Widget _buildServerCard(BuildContext context) {
    return _buildCard(context, title: 'Embedded server', child: SelectableText('Port: ${droidGateClient.port}\nBase URL: ${droidGateClient.baseUrl}'));
  }

  Widget _buildIconCard(BuildContext context) {
    return _buildCard(
      context,
      title: 'Application icon',
      child: Align(
        alignment: Alignment.centerLeft,
        child: Image.network(
          iconUrl,
          width: 96,
          height: 96,
          errorBuilder: (context, error, stackTrace) => SelectableText(error.toString(), style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, _DemoRequest request) {
    return _buildCard(
      context,
      title: request.title,
      child: FutureBuilder<Object?>(
        future: request.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return SelectionArea(
              child: Text.rich(
                highlighter.highlight(formatError(snapshot.error)),
                softWrap: true,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.error),
              ),
            );
          }
          return SelectionArea(
            child: Text.rich(
              highlighter.highlight(formatResult(snapshot.data)),
              softWrap: true,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required Widget child}) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, child: child),
          ],
        ),
      ),
    );
  }
}

class _DemoRequest {
  const _DemoRequest({required this.title, required this.future});

  final String title;
  final Future<Object?> future;
}
