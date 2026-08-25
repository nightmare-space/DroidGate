package com.nightmare.droidgate.plugins;

import static fi.iki.elonen.NanoHTTPD.newFixedLengthResponse;

import android.app.ActivityOptions;
import android.app.IActivityManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import android.os.ServiceManager;

import com.nightmare.droidgate.foundation.DroidGatePlugin;
import com.nightmare.droidgate.foundation.FakeContext;

import org.json.JSONException;
import org.json.JSONObject;

import fi.iki.elonen.NanoHTTPD;

/**
 * Example plugin showing how a DroidGate plugin can call a hidden Binder API.
 */
public class ActivityManagerPlugin extends DroidGatePlugin {
    private IActivityManager activityManager;

    @Override
    public String route() {
        return "/activity_manager";
    }

    @Override
    public NanoHTTPD.Response handle(NanoHTTPD.IHTTPSession session) {
        String action = session.getParms().get("action");
        if (action == null) {
            return response(NanoHTTPD.Response.Status.BAD_REQUEST, "missing action");
        }

        try {
            switch (action) {
                case "start_activity":
                    startActivity(
                            session.getParms().get("package"),
                            session.getParms().get("activity"),
                            session.getParms().get("displayId"),
                            parseInt(session.getParms().get("userId"), -2)
                    );
                    return response(NanoHTTPD.Response.Status.OK, "success");
                case "stop_activity":
                    getActivityManager().forceStopPackage(session.getParms().get("package"), -2);
                    return response(NanoHTTPD.Response.Status.OK, "success");
                case "remove_task":
                    getActivityManager().removeTask(Integer.parseInt(session.getParms().get("id")));
                    return response(NanoHTTPD.Response.Status.OK, "success");
                default:
                    return response(NanoHTTPD.Response.Status.BAD_REQUEST, "unknown action");
            }
        } catch (RemoteException | IllegalArgumentException error) {
            return response(NanoHTTPD.Response.Status.INTERNAL_ERROR, error.toString());
        }
    }

    private IActivityManager getActivityManager() {
        if (activityManager == null) {
            IBinder binder = ServiceManager.getService(Context.ACTIVITY_SERVICE);
            if (binder == null) {
                throw new IllegalStateException("ActivityManager binder is unavailable");
            }
            activityManager = IActivityManager.Stub.asInterface(binder);
        }
        return activityManager;
    }

    private void startActivity(String packageName, String activity, String displayId, int userId) throws RemoteException {
        if (packageName == null || activity == null) {
            throw new IllegalArgumentException("package and activity are required");
        }

        Intent intent = new Intent();
        intent.setClassName(packageName, activity);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        Bundle options = null;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && displayId != null) {
            ActivityOptions activityOptions = ActivityOptions.makeBasic();
            activityOptions.setLaunchDisplayId(Integer.parseInt(displayId));
            options = activityOptions.toBundle();
        }

        getActivityManager().startActivityAsUser(null, FakeContext.PACKAGE_NAME, intent, null, null, null, 0, 0, null, options, userId);
    }

    private int parseInt(String value, int fallback) {
        return value == null ? fallback : Integer.parseInt(value);
    }

    private NanoHTTPD.Response response(NanoHTTPD.Response.Status status, String result) {
        try {
            JSONObject body = new JSONObject();
            body.put("result", result);
            return newFixedLengthResponse(status, "application/json", body.toString());
        } catch (JSONException error) {
            throw new RuntimeException(error);
        }
    }
}
