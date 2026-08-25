package com.nightmare.droidgate;

import android.util.Log;

import com.nightmare.droidgate.foundation.DroidGatePlugin;
import com.nightmare.droidgate.helper.L;

import org.json.JSONObject;

import fi.iki.elonen.NanoHTTPD;

public class DroidGateHttpServer extends NanoHTTPD {
    public DroidGateHttpServer(String address, int port) {
        super(address, port);
    }


    DroidGateServer droidGateServer;
    String key;

    void setDroidGateServer(DroidGateServer droidGateServer) {
        this.droidGateServer = droidGateServer;
    }

    @Override
    public Response serve(IHTTPSession session) {
        try {
            String url = session.getUri();
            Log.d("DroidGateHttpServer", "url -> " + url);
            if (url.startsWith("/check")) {
                return newFixedLengthResponse(Response.Status.OK, "text/plain", "ok");
            }
            // extract key from header
            String key = session.getHeaders().get("key");
            if (key == null) {
                key = session.getParms().get("key");
            }
            if (key == null) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("result", "You need set key to request header");
                return newFixedLengthResponse(Response.Status.BAD_REQUEST, "application/json", jsonObject.toString());
            }
            if (this.key == null) {
                this.key = key;
            }
            if (!key.equals(this.key)) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("result", "You need use the same key what you first request");
                return newFixedLengthResponse(Response.Status.BAD_REQUEST, "application/json", jsonObject.toString());
            }
            for (DroidGatePlugin plugin : droidGateServer.plugins) {
                if (!plugin.route().isEmpty() && url.startsWith(plugin.route())) {
                    // log the request
                    L.d("request url: " + url + " param: " + session.getParms());
                    return plugin.handle(session);
                }
            }
            return newFixedLengthResponse(Response.Status.NOT_FOUND, "text/plain", "route not found");
        } catch (Throwable throwable) {
            // noinspection CallToPrintStackTrace
            // log error
            Log.e("DroidGateHttpServer", "error in serve", throwable);
            throwable.printStackTrace();
            JSONObject jsonObject = new JSONObject();
            try {
                jsonObject.put("success", false);
                jsonObject.put("error", "server_error");
                jsonObject.put("exception", throwable.getClass().getName());
                jsonObject.put("detail", throwable.getMessage() == null ? JSONObject.NULL : throwable.getMessage());
            } catch (Exception ignored) {
            }
            return newFixedLengthResponse(Response.Status.INTERNAL_ERROR, "application/json", jsonObject.toString());
        }
    }
}
