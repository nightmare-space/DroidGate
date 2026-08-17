package com.nightmare.droidgate_flutter;

import android.util.Log;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.nightmare.droidgate.DroidGate;
import com.nightmare.droidgate.helper.L;

/**
 * Starts an embedded DroidGate server when Flutter attaches the plugin.
 */
public class DroidGateFlutterPlugin implements FlutterPlugin, MethodCallHandler {
    private static final String TAG = "DroidGateFlutter";
    static List<FlutterEngine> flutterEngines = new ArrayList<>();

    public static void addFlutterEngine(FlutterEngine flutterEngine) {
        flutterEngines.add(flutterEngine);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        FlutterEngine flutterEngine = flutterPluginBinding.getFlutterEngine();
        if (flutterEngines.contains(flutterEngine)) {
            Log.d(TAG, "this engine does not need another DroidGate server");
            return;
        }
        L.configureForEmbededMode();
        try {
            int port = DroidGate.startServerFromActivity(flutterPluginBinding.getApplicationContext());
            Log.d(TAG, "port -> " + port);
        } catch (Exception e) {
            Log.d(TAG, "error -> " + e);
            e.printStackTrace();
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }
}
