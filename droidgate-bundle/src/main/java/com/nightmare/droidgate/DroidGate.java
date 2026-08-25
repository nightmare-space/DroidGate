package com.nightmare.droidgate;

import android.content.Context;
import android.os.Looper;

import com.nightmare.droidgate.foundation.DroidGatePlugin;
import com.nightmare.droidgate.helper.L;
import com.nightmare.droidgate.plugins.ActivityManagerPlugin;
import com.nightmare.droidgate.plugins.CodecPlugin;
import com.nightmare.droidgate.plugins.DeviceInfoPlugin;

/**
 * Ready-to-use DroidGate distribution containing the open-source example plugins.
 */
public final class DroidGate {
    private DroidGate() {
    }

    public static void main(String... args) {
        int status = 0;
        try {
            internalMain(args);
        } catch (Throwable error) {
            logError("Uncaught exception", error);
            status = 1;
        } finally {
            System.exit(status);
        }
    }

    public static void internalMain(String[] args) {
        Thread.setDefaultUncaughtExceptionHandler((thread, error) -> logError("Exception on thread: " + thread, error));

        int status = 0;
        try {
            DroidGateServer server = new DroidGateServer();
            server.startServerForShell(args);
            registerRoutes(server);
            L.d("success start port -> " + server.httpServer.getListeningPort() + ".");
            Looper.loop();
        } catch (Throwable error) {
            logError("Failed to run DroidGate", error);
            status = 1;
        } finally {
            System.exit(status);
        }
    }

    public static int startServerFromActivity(Context context) {
        DroidGateServer server = new DroidGateServer();
        int port = server.startServerFromActivity(context);
        registerRoutes(server);
        return port;
    }

    private static void registerRoutes(DroidGateServer server) {
        registerPlugin(server, ActivityManagerPlugin::new);
        registerPlugin(server, CodecPlugin::new);
        registerPlugin(server, DeviceInfoPlugin::new);
    }

    private static void registerPlugin(DroidGateServer server, PluginFactory factory) {
        try {
            server.registerPlugin(factory.create());
        } catch (LinkageError | RuntimeException error) {
            logError("Failed to register plugin", error);
        }
    }

    private static void logError(String message, Throwable error) {
        L.e(message + ": " + error);
        for (StackTraceElement stack : error.getStackTrace()) {
            L.e("\tat " + stack);
        }
    }

    @FunctionalInterface
    private interface PluginFactory {
        DroidGatePlugin create();
    }
}
