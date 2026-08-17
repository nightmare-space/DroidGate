package com.nightmare.droidgate;

import com.nightmare.droidgate.helper.L;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Random;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

public class JNIBridge {
    static {
        // 测试方式一：直接操作 ZIP
        loadLibraryFromZipArtifact();

        // 测试方式二：通过 ClassLoader 读取资源
        // loadLibraryFromClassPathResource();
    }

    /**
     * 方式一：
     * 根据 java.class.path 找到 droidgate-server，
     * 手动使用 ZipFile 读取其中的 libdroidgate.so。
     */
    private static void loadLibraryFromZipArtifact() {
        String classPath = System.getProperty("java.class.path");
        if (classPath == null || classPath.isEmpty()) {
            throw new UnsatisfiedLinkError("java.class.path is empty");
        }

        String libraryName = System.mapLibraryName("droidgate");
        File output = new File(
                "/data/local/tmp",
                libraryName
        );

        try (ZipFile artifact = new ZipFile(classPath)) {
            ZipEntry libraryEntry = artifact.getEntry(libraryName);
            if (libraryEntry == null) {
                throw new IOException(
                        libraryName + " not found in " + classPath
                );
            }

            try (InputStream input =
                         artifact.getInputStream(libraryEntry)) {
                copyToFile(input, output);
            }

            System.load(output.getAbsolutePath());
        } catch (IOException exception) {
            throw createLoadError(
                    "Unable to extract library from " + classPath,
                    exception
            );
        }
    }

    /**
     * 方式二：
     * 让加载 JNIBridge 的 ClassLoader 在 classpath 中寻找
     * libdroidgate.so，并将其作为普通资源读取。
     */
    private static void loadLibraryFromClassPathResource() {
        String libraryName = System.mapLibraryName("droidgate");
        String resourceName = "/" + libraryName;

        File output = new File(
                "/data/local/tmp",
                libraryName
        );

        try (InputStream input =
                     JNIBridge.class.getResourceAsStream(resourceName)) {
            if (input == null) {
                throw new IOException(
                        "Classpath resource not found: " + resourceName
                );
            }

            copyToFile(input, output);
            System.load(output.getAbsolutePath());
        } catch (IOException exception) {
            throw createLoadError(
                    "Unable to extract classpath resource "
                            + resourceName,
                    exception
            );
        }
    }

    /**
     * 两种加载方式公用的文件复制方法。
     */
    private static void copyToFile(
            InputStream input,
            File output
    ) throws IOException {
        try (FileOutputStream outputStream =
                     new FileOutputStream(output)) {
            byte[] buffer = new byte[8192];
            int length;

            while ((length = input.read(buffer)) != -1) {
                outputStream.write(buffer, 0, length);
            }

            outputStream.flush();
        }
    }

    private static UnsatisfiedLinkError createLoadError(
            String message,
            Throwable cause
    ) {
        UnsatisfiedLinkError error =
                new UnsatisfiedLinkError(
                        message + ": " + cause.getMessage()
                );
        error.initCause(cause);
        return error;
    }

    public static native long sumSquaresNative(int n);


    public static native long fibNative(int n);


    public static void main(String[] args) {
        int n = 10_000_000;

        // Java 计算
        long startJava = System.nanoTime();
        long sumJava = sumSquaresJava(n);
        long endJava = System.nanoTime();
        System.out.println("Java 计算结果: " + sumJava + " | 耗时: " + (endJava - startJava) / 1e6 + " ms");

        // C 计算
        long startC = System.nanoTime();
        long sumC = sumSquaresNative(n);
        long endC = System.nanoTime();
        System.out.println("C 计算结果: " + sumC + " | 耗时: " + (endC - startC) / 1e6 + " ms");

    }

    public static long fibJava(int n) {
        if (n <= 1) return n;
        long a = 0, b = 1;
        for (int i = 2; i <= n; i++) {
            long temp = a + b;
            a = b;
            b = temp;
        }
        return b;
    }

    public static void test() {
        int samples = 100_000_000;

        // Java 计算
        long startJava = System.nanoTime();
        double piJava = monteCarloJava(samples);
        long endJava = System.nanoTime();
        System.out.println("Java 计算 π: " + piJava + " | 耗时: " + (endJava - startJava) / 1e6 + " ms");

        // C 计算
        long startC = System.nanoTime();
        double piC = monteCarloNative(samples);
        long endC = System.nanoTime();
        System.out.println("C 计算 π: " + piC + " | 耗时: " + (endC - startC) / 1e6 + " ms");

    }

    public static void test1() {
        int n = 100;

        long startJava = System.nanoTime();
        long resultJava = fibJava(n);
        long endJava = System.nanoTime();
        System.out.println("Java 结果: " + resultJava + " | 耗时: " + (endJava - startJava) / 1e6 + " ms");

        long startC = System.nanoTime();
        long resultC = fibNative(n);
        long endC = System.nanoTime();
        System.out.println("C 结果: " + resultC + " | 耗时: " + (endC - startC) / 1e6 + " ms");
    }

    public static double monteCarloJava(int samples) {
        Random random = new Random();
        int insideCircle = 0;
        for (int i = 0; i < samples; i++) {
            double x = random.nextDouble();
            double y = random.nextDouble();
            if (x * x + y * y <= 1.0) {
                insideCircle++;
            }
        }
        return 4.0 * insideCircle / samples;
    }

    public static native double monteCarloNative(int samples);

    public static long sumSquaresJava(int n) {
        long sum = 0;
        for (int i = 1; i <= n; i++) {
            sum += (long) i * i;
        }
        return sum;
    }

    public static native boolean setUid(int uid);

    // 打开虚拟鼠标（初始化 /dev/uinput）
    public static native int nativeOpen();

    // 移动鼠标
    public static native void nativeMove(int dx, int dy);

    // 左键点击
    public static native void nativeClickLeft();

    // 关闭并销毁虚拟鼠标设备
    public static native void nativeClose();

    public static native int nativeMoveMouse(int dx, int dy);
}
