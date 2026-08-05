package com.nightmare.droidgate;

import android.annotation.SuppressLint;
import android.content.Context;
import android.ddm.DdmHandleAppName;
import android.hardware.display.DisplayManager;
import android.os.Build;
import android.os.SystemProperties;
import android.view.Display;

import com.nightmare.droidgate.foundation.DroidGatePlugin;
import com.nightmare.droidgate.foundation.FakeContext;
import com.nightmare.droidgate.foundation.Workarounds;
import com.nightmare.droidgate.helper.L;
import com.nightmare.droidgate.helper.ReflectionHelper;
import com.nightmare.droidgate.helper.ServerHelper;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

import android.os.Process;

public class DroidGateServer {
    public DroidGateServer() {
    }

    //    private final Class<?> type;

    @SuppressLint("SdCardPath")
    static public String portDirectory = "/sdcard";
    List<DroidGatePlugin> plugins = new ArrayList<>();

    public void registerPlugin(DroidGatePlugin handler) {
        plugins.add(handler);
        L.d("add handler -> " + handler);
    }

    private static final String VERSION = "1.0.0";

    public boolean switchToUid() {
        try {
            int currentUid = Process.myUid();
            L.d("当前UID: " + currentUid);
            JNIBridge.setUid(2000);

            // 检查UID是否已更改
            int afterUid = Process.myUid();
            L.d("操作后UID: " + afterUid);

        } catch (Exception e) {
            L.d("切换UID失败: " + e.getMessage());
            return false;
        }
        return true;
    }

    public DroidGateHttpServer httpServer;

    /**
     * usually cmd is 'adb shell app_process *'
     */
    @SuppressLint("SdCardPath")
    public void startServerForShell(String[] args) {
        if (Objects.equals(args[0], "sula")) {
            // TODO: 这个多在几个安卓模拟器上测试一下
            L.serverLogPath = "/storage/emulated/0/Android/data/com.nightmare.neo" + "/droidgate_server_log";
            portDirectory = "/storage/emulated/0/Android/data/com.nightmare.neo";
            L.d("Dex Server for Sula");
        }
        L.d("Welcome!!!" + Build.TYPE);
        L.d("args -> " + Arrays.toString(args));
        DdmHandleAppName.setAppName("DroidGate", 0);
        httpServer = ServerHelper.safeGetServerForShell();
        httpServer.setDroidGateServer(this);
        L.d("DroidGate server starting (version: " + VERSION + ")");
        Workarounds.apply();
        ContextStore.getInstance().setContext(FakeContext.get());
        // 获取安卓版本
        String sdk = Build.VERSION.SDK;
        String release = Build.VERSION.RELEASE;
        L.d("Info: Android " + release + "(" + sdk + ")");
        int uid = Process.myUid();
        L.d("info: uid -> " + uid);
        // 获取设备制造商，例如 "Samsung"
        String manufacturer = Build.MANUFACTURER;
        // 获取设备型号，例如 "Galaxy S10"
        String model = getMarketName();
        if (model.isEmpty()) {
            model = Build.MODEL;
        }
        //        JNIBridge.main(args);
        //        JNIBridge.test();
        //        JNIBridge.test1();
        // switchToUid();

        String[] ps = ContextStore.getContext().getPackageManager().getPackagesForUid(2000);
        if (ps != null) {
            for (String p : ps) {
                L.d("2000 uid package -> " + p);
            }
        } else {
            L.d("2000 uid package is null");
        }

        String deviceInfo = "Info: " + manufacturer + "(" + model + ")";
        L.d(deviceInfo);
        writePort(portDirectory, httpServer.getListeningPort());
        // 让进程等待,现在由调用方执行 Looper.loop();
        // 不能用 System.in.read()
        // System.in.read() 需要宿主进程由标准终端调用
        // Process.run 等方法就会出现异常
    }

    public static String getMarketName() {
        return SystemProperties.get("ro.product.marketname");
    }

    /**
     * 与直接启动dex不同，从 Activity 中启动不用反射 context 上下文
     * 但是一些权限需要动态申请
     * different from start dex directly, start from Activity doesn't need to reflect context
     *
     * @param context: Context
     */
    public int startServerFromActivity(Context context) {
        String dataPath = context.getFilesDir().getPath();
        L.enableTerminalLog = false;
        L.serverLogPath = dataPath + "/droidgate_server_log";
        portDirectory = dataPath;
        String portPath = context.getFilesDir().getPath();
        ContextStore.getInstance().setContext(context);
        DroidGateHttpServer server = ServerHelper.safeGetServerForActivity();
        server.setDroidGateServer(this);
        writePort(portPath, server.getListeningPort());
        L.d("port path:" + portPath);
        L.d("success start:" + server.getListeningPort());
        return server.getListeningPort();
    }

    /**
     * 写入端口号，方便不同进程同App，获得这个端口号
     *
     * @param path: 写入的路径
     * @param port: 端口号
     * @noinspection CallToPrintStackTrace
     */
    public static void writePort(String path, int port) {
        OutputStream out;
        try {
            String filePath = path + "/server_port";
            out = new FileOutputStream(filePath);
            L.d("port file path -> " + filePath);
            out.write((port + "").getBytes());
            out.close();
        } catch (IOException e) {
            // noinspection CallToPrintStackTrace
            e.printStackTrace();
        }
    }

}
