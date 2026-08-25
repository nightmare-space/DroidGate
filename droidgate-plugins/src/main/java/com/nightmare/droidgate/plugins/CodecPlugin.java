package com.nightmare.droidgate.plugins;

import static fi.iki.elonen.NanoHTTPD.newFixedLengthResponse;

import android.media.MediaCodecInfo;
import android.media.MediaCodecList;

import com.nightmare.droidgate.foundation.DroidGatePlugin;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import fi.iki.elonen.NanoHTTPD;

/**
 * Example plugin using public Android framework APIs.
 */
public class CodecPlugin extends DroidGatePlugin {
    @Override
    public String route() {
        return "/codec";
    }

    @Override
    public NanoHTTPD.Response handle(NanoHTTPD.IHTTPSession session) {
        String action = session.getParms().get("action");
        if (!"get_codec_list".equals(action)) {
            return newFixedLengthResponse(NanoHTTPD.Response.Status.BAD_REQUEST, "text/plain", "unknown action");
        }

        try {
            JSONArray codecs = new JSONArray();
            MediaCodecList codecList = new MediaCodecList(MediaCodecList.REGULAR_CODECS);
            for (MediaCodecInfo codecInfo : codecList.getCodecInfos()) {
                for (String type : codecInfo.getSupportedTypes()) {
                    JSONObject codec = new JSONObject();
                    codec.put("name", codecInfo.getName());
                    codec.put("type", type);
                    codec.put("isEncoder", codecInfo.isEncoder());
                    codecs.put(codec);
                }
            }

            JSONObject result = new JSONObject();
            result.put("datas", codecs);
            return newFixedLengthResponse(NanoHTTPD.Response.Status.OK, "application/json", result.toString());
        } catch (JSONException error) {
            throw new RuntimeException(error);
        }
    }
}
