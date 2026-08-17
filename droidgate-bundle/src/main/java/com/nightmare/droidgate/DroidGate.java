package com.nightmare.droidgate;

import android.content.Context;
import android.os.Looper;

import com.nightmare.droidgate.foundation.DroidGatePlugin;
import com.nightmare.droidgate.helper.L;
import com.nightmare.droidgate.plugins.ActivityManagerPlugin;
import com.nightmare.droidgate.plugins.ActivityTaskManagerPlugin;
import com.nightmare.droidgate.plugins.CodecPlugin;
import com.nightmare.droidgate.plugins.DeviceInfoPlugin;
import com.nightmare.droidgate.plugins.DisplayManagerPlugin;
import com.nightmare.droidgate.plugins.FilePlugin;
import com.nightmare.droidgate.plugins.InputManagerPlugin;
import com.nightmare.droidgate.plugins.NotificationPlugin;
import com.nightmare.droidgate.plugins.PackageManagerPlugin;
import com.nightmare.droidgate.plugins.UserManagerPlugin;

import java.io.FileDescriptor;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.Arrays;

public class DroidGate {
    private static final PrintStream CONSOLE_OUT = new PrintStream(new FileOutputStream(FileDescriptor.out));
    private static final PrintStream CONSOLE_ERR = new PrintStream(new FileOutputStream(FileDescriptor.err));


    public static void main(String... args) {
        int status = 0;
        try {
            internalMain(args);
        } catch (Throwable throwable) {
            L.e("Uncaught exception: " + throwable.getMessage());
            StackTraceElement[] stacks = throwable.getStackTrace();
            for (StackTraceElement stack : stacks) {
                L.e("\tat " + stack.toString());
            }
            // throwable.printStackTrace(CONSOLE_ERR);
            status = 1;
        } finally {
            // By default, the Java process exits when all non-daemon threads are terminated.
            // The Android SDK might start some non-daemon threads internally, preventing the scrcpy server to exit.
            // So force the process to exit explicitly.
            System.exit(status);
        }
    }

    static public void internalMain(String[] args) {
        Thread.setDefaultUncaughtExceptionHandler((t, e) -> {
            L.e("Exception on thread: " + t);
            L.e("Message: " + e.getMessage());
            StackTraceElement[] stacks = e.getStackTrace();
            for (StackTraceElement stack : stacks) {
                L.e("\tat " + stack.toString());
            }
        });
        int status = 0;
        try {
            DroidGateServer server = new DroidGateServer();
            server.startServerForShell(args);
            registerRoutes(server);
            L.d("success start port -> " + server.httpServer.getListeningPort() + ".");
            Looper.loop();
        } catch (Throwable t) {
            L.e(t.getMessage());
            status = 1;
        } finally {
            // By default, the Java process exits when all non-daemon threads are terminated.
            // The Android SDK might start some non-daemon threads internally, preventing the scrcpy server to exit.
            // So force the process to exit explicitly.
            System.exit(status);
        }
    }

    public static int startServerFromActivity(Context context) {
        DroidGateServer server = new DroidGateServer();
        int port = server.startServerFromActivity(context);
        registerRoutes(server);
        return port;
    }

    @FunctionalInterface
    private interface PluginFactory {
        DroidGatePlugin create();
    }

    private static void registerPlugin(
            DroidGateServer server,
            PluginFactory factory
    ) {
        try {
            DroidGatePlugin plugin = factory.create();
            server.registerPlugin(plugin);
        } catch (LinkageError | RuntimeException error) {
            L.e("Failed to register plugin: " + error);
            error.printStackTrace();
        }
    }

    private static void registerRoutes(DroidGateServer server) {
        registerPlugin(server, ActivityManagerPlugin::new);
        registerPlugin(server, ActivityTaskManagerPlugin::new);
        registerPlugin(server, CodecPlugin::new);
        registerPlugin(server, DeviceInfoPlugin::new);
        registerPlugin(server, DisplayManagerPlugin::new);
        registerPlugin(server, FilePlugin::new);
        registerPlugin(server, InputManagerPlugin::new);
        registerPlugin(server, NotificationPlugin::new);
        registerPlugin(server, PackageManagerPlugin::new);
        registerPlugin(server, UserManagerPlugin::new);
    }
}
