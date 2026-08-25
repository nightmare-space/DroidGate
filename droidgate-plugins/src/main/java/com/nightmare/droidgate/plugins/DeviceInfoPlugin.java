package com.nightmare.droidgate.plugins;

import static fi.iki.elonen.NanoHTTPD.newFixedLengthResponse;

import com.nightmare.droidgate.foundation.DroidGatePlugin;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import fi.iki.elonen.NanoHTTPD;

/**
 * Example plugin reading Linux procfs and sysfs data.
 */
public class DeviceInfoPlugin extends DroidGatePlugin {
    @Override
    public String route() {
        return "/device_info";
    }

    private String readFileContent(String filePath) {
        File file = new File(filePath);
        if (!file.exists()) {
            return null;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            StringBuilder content = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                content.append(line);
            }
            return content.toString();
        } catch (IOException error) {
            return null;
        }
    }

    @Override
    public NanoHTTPD.Response handle(NanoHTTPD.IHTTPSession session) {
        if ("proc_stat".equals(session.getParms().get("action"))) {
            String result = readFileContent("/proc/stat");
            return newFixedLengthResponse(NanoHTTPD.Response.Status.OK, "text/plain", result == null ? "" : result);
        }

        try {
            JSONObject result = new JSONObject();
            JSONArray cpu = new JSONArray();
            File cpuDirectory = new File("/sys/devices/system/cpu");
            File[] cpuDirectories = cpuDirectory.listFiles(file -> file.isDirectory() && file.getName().matches("cpu\\d+"));
            if (cpuDirectories != null) {
                for (File directory : cpuDirectories) {
                    JSONObject cpuInfo = new JSONObject();
                    putIntegerFile(cpuInfo, "scaling_cur_freq", new File(directory, "cpufreq/scaling_cur_freq"));
                    putIntegerFile(cpuInfo, "scaling_min_freq", new File(directory, "cpufreq/scaling_min_freq"));
                    putIntegerFile(cpuInfo, "scaling_max_freq", new File(directory, "cpufreq/scaling_max_freq"));
                    cpu.put(cpuInfo);
                }
            }
            result.put("cpu", cpu);

            JSONArray gpu = new JSONArray();
            String gpuContent = readFileContent("/sys/class/kgsl/kgsl-3d0/gpubusy");
            if (gpuContent != null) {
                String[] values = gpuContent.trim().split("\\s+");
                if (values.length >= 2) {
                    gpu.put(Long.parseLong(values[0]));
                    gpu.put(Long.parseLong(values[1]));
                }
            }
            result.put("gpu", gpu);
            return newFixedLengthResponse(NanoHTTPD.Response.Status.OK, "application/json", result.toString());
        } catch (JSONException | NumberFormatException error) {
            throw new RuntimeException(error);
        }
    }

    private void putIntegerFile(JSONObject target, String key, File file) throws JSONException {
        String content = readFileContent(file.getAbsolutePath());
        if (content != null) {
            target.put(key, Long.parseLong(content.trim()));
        }
    }
}
