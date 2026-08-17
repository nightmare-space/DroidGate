package com.nightmare.droidgate.plugins;

import static fi.iki.elonen.NanoHTTPD.newFixedLengthResponse;

import android.app.IActivityManager;
import android.content.Context;
import android.content.pm.IPackageManager;
import android.os.IBinder;
import android.os.IUserManager;
import android.os.ServiceManager;

import com.nightmare.droidgate.foundation.DroidGatePlugin;
import com.nightmare.droidgate.helper.ReflectionHelper;

import org.json.JSONArray;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import fi.iki.elonen.NanoHTTPD;

/**
 * Exposes selected hidden IUserManager APIs that are not fully represented by
 * {@code pm create-user} and {@code pm remove-user}.
 *
 * <p>Removal is deliberately limited to confirmed clone profiles. Full users,
 * the system user, and device-policy bypasses are not exposed over HTTP.</p>
 */
public class UserManagerPlugin extends DroidGatePlugin {
    private static final String MIME_JSON = "application/json";
    private static final String CLONE_PROFILE_TYPE = "android.os.usertype.profile.CLONE";
    private static final long DEFAULT_WAIT_TIMEOUT_MS = 30_000L;
    private static final long MAX_WAIT_TIMEOUT_MS = 120_000L;

    private final IUserManager userManager;
    private final Throwable initializationError;
    private IActivityManager activityManager;
    private IPackageManager packageManager;

    public UserManagerPlugin() {
        IUserManager resolvedManager = null;
        Throwable error = null;
        try {
            IBinder binder = ServiceManager.getService(Context.USER_SERVICE);
            if (binder == null) {
                throw new IllegalStateException("UserManager binder is unavailable");
            }
            resolvedManager = IUserManager.Stub.asInterface(binder);
            if (resolvedManager == null) {
                throw new IllegalStateException("IUserManager is unavailable");
            }
        } catch (Throwable throwable) {
            error = unwrap(throwable);
        }
        userManager = resolvedManager;
        initializationError = error;
    }

    @Override
    public String route() {
        return "/user_manager";
    }

    @Override
    public NanoHTTPD.Response handle(NanoHTTPD.IHTTPSession session) {
        if (initializationError != null) {
            return errorResponse(NanoHTTPD.Response.Status.INTERNAL_ERROR, "initialization_failed", initializationError);
        }

        Map<String, String> params;
        try {
            params = getRequestParams(session);
        } catch (Throwable throwable) {
            return errorResponse(NanoHTTPD.Response.Status.BAD_REQUEST, "invalid_request_body", unwrap(throwable));
        }
        String action = params.get("action");
        if (action == null || action.isEmpty()) {
            return errorResponse(NanoHTTPD.Response.Status.BAD_REQUEST, "missing action", null);
        }

        try {
            switch (action) {
                case "create_user":
                    return createUser(params);
                case "create_profile":
                    return createProfile(params);
                case "pre_create_user":
                    return preCreateUser(params);
                case "remove_profile":
                    return removeProfile(params);
                case "start_profile":
                    return startProfile(params);
                case "stop_profile":
                    return stopProfile(params);
                case "install_existing_package":
                    return installExistingPackage(params);
                case "get_user":
                    return getUser(params);
                case "get_users":
                    return getUsers(params);
                default:
                    return errorResponse(NanoHTTPD.Response.Status.BAD_REQUEST, "unknown action: " + action, null);
            }
        } catch (IllegalArgumentException exception) {
            return errorResponse(NanoHTTPD.Response.Status.BAD_REQUEST, exception.getMessage(), exception);
        } catch (Throwable throwable) {
            return errorResponse(NanoHTTPD.Response.Status.INTERNAL_ERROR, "operation_failed", unwrap(throwable));
        }
    }

    private Map<String, String> getRequestParams(NanoHTTPD.IHTTPSession session) throws Exception {
        if (session.getMethod() != NanoHTTPD.Method.POST) {
            return session.getParms();
        }

        Map<String, String> files = new HashMap<>();
        session.parseBody(files);
        Map<String, String> params = new HashMap<>(session.getParms());
        String contentType = session.getHeaders().get("content-type");
        if (contentType == null || !contentType.split(";", 2)[0].trim().equalsIgnoreCase("application/json")) {
            return params;
        }

        String body = files.get("postData");
        if (body == null || body.trim().isEmpty()) {
            throw new IllegalArgumentException("empty JSON body");
        }
        JSONObject json = new JSONObject(body);
        Iterator<String> keys = json.keys();
        while (keys.hasNext()) {
            String key = keys.next();
            Object value = json.get(key);
            if (value == JSONObject.NULL) {
                continue;
            }
            if (value instanceof JSONArray) {
                JSONArray array = (JSONArray) value;
                StringBuilder joined = new StringBuilder();
                for (int i = 0; i < array.length(); i++) {
                    if (i > 0) {
                        joined.append(',');
                    }
                    joined.append(array.getString(i));
                }
                params.put(key, joined.toString());
            } else {
                params.put(key, String.valueOf(value));
            }
        }
        return params;
    }

    private NanoHTTPD.Response createUser(Map<String, String> params) throws Throwable {
        String name = require(params, "name");
        String userType = params.get("user_type");
        if (userType == null || userType.isEmpty()) {
            userType = "android.os.usertype.full.SECONDARY";
        }
        int flags = parseFlags(params.get("flags"));

        Object userInfo = invoke(
                "createUserWithThrow",
                new Class<?>[]{String.class, String.class, int.class},
                name,
                userType,
                flags
        );
        return userResult("create_user", userInfo);
    }

    private NanoHTTPD.Response createProfile(Map<String, String> params) throws Throwable {
        String name = require(params, "name");
        String userType = params.get("user_type");
        if (userType == null || userType.isEmpty()) {
            userType = CLONE_PROFILE_TYPE;
        }
        int flags = parseFlags(params.get("flags"));
        int parentUserId = parseRequiredInt(params, "parent_user_id");
        String[] disallowedPackages = parseStringList(params.get("disallowed_packages"));
        boolean evenWhenDisallowed = parseBoolean(params.get("even_when_disallowed"), false);
        String methodName = evenWhenDisallowed
                ? "createProfileForUserEvenWhenDisallowedWithThrow"
                : "createProfileForUserWithThrow";

        Object userInfo = invoke(
                methodName,
                new Class<?>[]{String.class, String.class, int.class, int.class, String[].class},
                name,
                userType,
                flags,
                parentUserId,
                disallowedPackages
        );
        return userResult("create_profile", userInfo);
    }

    private NanoHTTPD.Response preCreateUser(Map<String, String> params) throws Throwable {
        String userType = require(params, "user_type");
        Object userInfo = invoke("preCreateUserWithThrow", new Class<?>[]{String.class}, userType);
        return userResult("pre_create_user", userInfo);
    }

    private NanoHTTPD.Response removeProfile(Map<String, String> params) throws Throwable {
        int userId = parseRequiredInt(params, "user_id");
        int confirmUserId = parseRequiredInt(params, "confirm_user_id");
        if (userId != confirmUserId) {
            throw new IllegalArgumentException("confirm_user_id must equal user_id");
        }
        if (userId == 0) {
            throw new IllegalArgumentException("system user 0 cannot be removed");
        }

        Object userInfo = getUserInfo(userId);
        if (userInfo == null) {
            throw new IllegalArgumentException("user does not exist: " + userId);
        }
        String userType = String.valueOf(readField(userInfo, "userType"));
        if (!userType.startsWith("android.os.usertype.profile.")) {
            throw new IllegalArgumentException("refusing to remove non-profile user " + userId + " of type " + userType);
        }

        String mode = params.get("mode");
        if (mode == null || mode.isEmpty()) {
            mode = "normal";
        }

        JSONObject json = new JSONObject();
        json.put("action", "remove_profile");
        json.put("user_id", userId);
        json.put("mode", mode);
        json.put("user_before_removal", userInfoToJson(userInfo));

        boolean accepted;
        if ("normal".equals(mode)) {
            accepted = (Boolean) invoke("removeUser", new Class<?>[]{int.class}, userId);
            json.put("binder_result", accepted);
        } else if ("when_possible".equals(mode)) {
            int result = (Integer) invoke(
                    "removeUserWhenPossible",
                    new Class<?>[]{int.class, boolean.class},
                    userId,
                    false
            );
            accepted = result == 0 || result == 1 || result == 2;
            json.put("binder_result", result);
            json.put("override_device_policy", false);
        } else {
            throw new IllegalArgumentException("unknown remove mode: " + mode);
        }

        boolean wait = parseBoolean(params.get("wait"), false);
        json.put("accepted", accepted);
        json.put("wait", wait);
        if (accepted && wait) {
            long timeoutMs = parseLong(params.get("timeout_ms"), DEFAULT_WAIT_TIMEOUT_MS);
            timeoutMs = Math.max(0L, Math.min(timeoutMs, MAX_WAIT_TIMEOUT_MS));
            json.put("removed", waitUntilRemoved(userId, timeoutMs));
            json.put("timeout_ms", timeoutMs);
        } else {
            json.put("removed", getUserInfo(userId) == null);
        }
        json.put("success", accepted);
        return jsonResponse(NanoHTTPD.Response.Status.OK, json);
    }

    private NanoHTTPD.Response startProfile(Map<String, String> params) throws Throwable {
        int userId = parseRequiredInt(params, "user_id");
        if (userId == 0) {
            throw new IllegalArgumentException("system user 0 is not a profile");
        }

        Object userInfo = getUserInfo(userId);
        if (userInfo == null) {
            throw new IllegalArgumentException("user does not exist: " + userId);
        }
        String userType = String.valueOf(readField(userInfo, "userType"));
        if (!userType.startsWith("android.os.usertype.profile.")) {
            throw new IllegalArgumentException("refusing to start non-profile user " + userId + " of type " + userType);
        }

        IActivityManager activityManager = getActivityManager();

        boolean binderResult;
        try {
            binderResult = ReflectionHelper.invokeMethodWithParam(
                    IActivityManager.class,
                    activityManager,
                    "startProfile",
                    new Class<?>[]{int.class},
                    userId
            );
        } catch (InvocationTargetException exception) {
            throw unwrap(exception);
        }

        JSONObject json = new JSONObject();
        json.put("success", binderResult);
        json.put("action", "start_profile");
        json.put("user_id", userId);
        json.put("binder_result", binderResult);
        json.put("user", userInfoToJson(userInfo));
        return jsonResponse(NanoHTTPD.Response.Status.OK, json);
    }

    private NanoHTTPD.Response stopProfile(Map<String, String> params) throws Throwable {
        int userId = parseRequiredInt(params, "user_id");
        if (userId == 0) {
            throw new IllegalArgumentException("system user 0 cannot be stopped");
        }

        Object userInfo = getUserInfo(userId);
        if (userInfo == null) {
            throw new IllegalArgumentException("user does not exist: " + userId);
        }
        String userType = String.valueOf(readField(userInfo, "userType"));
        if (!userType.startsWith("android.os.usertype.profile.")) {
            throw new IllegalArgumentException("refusing to stop non-profile user " + userId + " of type " + userType);
        }

        IActivityManager activityManager = getActivityManager();

        Object binderResult;
        try {
            binderResult = ReflectionHelper.invokeMethodWithParam(
                    IActivityManager.class,
                    activityManager,
                    "stopProfile",
                    new Class<?>[]{int.class},
                    userId
            );
        } catch (InvocationTargetException exception) {
            throw unwrap(exception);
        }

        JSONObject json = new JSONObject();
        boolean success = !(binderResult instanceof Boolean) || (Boolean) binderResult;
        json.put("success", success);
        json.put("action", "stop_profile");
        json.put("user_id", userId);
        json.put("binder_result", binderResult == null ? JSONObject.NULL : binderResult);
        json.put("user", userInfoToJson(userInfo));
        return jsonResponse(NanoHTTPD.Response.Status.OK, json);
    }

    private NanoHTTPD.Response installExistingPackage(Map<String, String> params) throws Throwable {
        String packageName = require(params, "package_name");
        int userId = parseRequiredInt(params, "user_id");
        if (getUserInfo(userId) == null) {
            throw new IllegalArgumentException("user does not exist: " + userId);
        }

        IPackageManager packageManager = getPackageManager();

        int result;
        try {
            result = ReflectionHelper.invokeMethodWithParam(
                    IPackageManager.class,
                    packageManager,
                    "installExistingPackageAsUser",
                    new Class<?>[]{String.class, int.class, int.class, int.class, List.class},
                    packageName,
                    userId,
                    0x00400000,
                    0,
                    null
            );
        } catch (InvocationTargetException exception) {
            throw unwrap(exception);
        }

        JSONObject json = new JSONObject();
        json.put("success", result == 1);
        json.put("action", "install_existing_package");
        json.put("package_name", packageName);
        json.put("user_id", userId);
        json.put("result", result);
        return jsonResponse(NanoHTTPD.Response.Status.OK, json);
    }

    private NanoHTTPD.Response getUser(Map<String, String> params) throws Throwable {
        int userId = parseRequiredInt(params, "user_id");
        Object userInfo = getUserInfo(userId);
        JSONObject json = new JSONObject();
        json.put("success", true);
        json.put("action", "get_user");
        json.put("user_id", userId);
        json.put("exists", userInfo != null);
        json.put("user", userInfo == null ? JSONObject.NULL : userInfoToJson(userInfo));
        return jsonResponse(NanoHTTPD.Response.Status.OK, json);
    }

    private NanoHTTPD.Response getUsers(Map<String, String> params) throws Throwable {
        boolean excludePartial = parseBoolean(params.get("exclude_partial"), true);
        boolean excludeDying = parseBoolean(params.get("exclude_dying"), false);
        boolean excludePreCreated = parseBoolean(params.get("exclude_pre_created"), true);
        Object result = invoke(
                "getUsers",
                new Class<?>[]{boolean.class, boolean.class, boolean.class},
                excludePartial,
                excludeDying,
                excludePreCreated
        );

        JSONArray users = new JSONArray();
        if (result instanceof List) {
            for (Object userInfo : (List<?>) result) {
                if (userInfo != null) {
                    JSONObject user = userInfoToJson(userInfo);
                    user.put("running", isUserRunning((Integer) readField(userInfo, "id")));
                    users.put(user);
                }
            }
        }

        JSONObject json = new JSONObject();
        json.put("success", true);
        json.put("action", "get_users");
        json.put("exclude_partial", excludePartial);
        json.put("exclude_dying", excludeDying);
        json.put("exclude_pre_created", excludePreCreated);
        json.put("count", users.length());
        json.put("users", users);
        return jsonResponse(NanoHTTPD.Response.Status.OK, json);
    }

    private boolean isUserRunning(int userId) throws Throwable {
        IActivityManager activityManager = getActivityManager();
        try {
            return ReflectionHelper.invokeMethodWithParam(
                    IActivityManager.class,
                    activityManager,
                    "isUserRunning",
                    new Class<?>[]{int.class, int.class},
                    userId,
                    0
            );
        } catch (InvocationTargetException exception) {
            throw unwrap(exception);
        }
    }

    private IActivityManager getActivityManager() {
        if (activityManager == null) {
            IBinder binder = ServiceManager.getService(Context.ACTIVITY_SERVICE);
            if (binder == null) {
                throw new IllegalStateException("ActivityManager binder is unavailable");
            }
            activityManager = IActivityManager.Stub.asInterface(binder);
            if (activityManager == null) {
                throw new IllegalStateException("IActivityManager is unavailable");
            }
        }
        return activityManager;
    }

    private IPackageManager getPackageManager() {
        if (packageManager == null) {
            IBinder binder = ServiceManager.getService("package");
            if (binder == null) {
                throw new IllegalStateException("PackageManager binder is unavailable");
            }
            packageManager = IPackageManager.Stub.asInterface(binder);
            if (packageManager == null) {
                throw new IllegalStateException("IPackageManager is unavailable");
            }
        }
        return packageManager;
    }

    private NanoHTTPD.Response userResult(String action, Object userInfo) throws Exception {
        JSONObject json = new JSONObject();
        json.put("success", userInfo != null);
        json.put("action", action);
        json.put("user", userInfo == null ? JSONObject.NULL : userInfoToJson(userInfo));
        return jsonResponse(NanoHTTPD.Response.Status.OK, json);
    }

    private Object getUserInfo(int userId) throws Throwable {
        return invoke("getUserInfo", new Class<?>[]{int.class}, userId);
    }

    private boolean waitUntilRemoved(int userId, long timeoutMs) throws Throwable {
        long deadline = System.currentTimeMillis() + timeoutMs;
        while (getUserInfo(userId) != null) {
            if (System.currentTimeMillis() >= deadline) {
                return false;
            }
            Thread.sleep(100L);
        }
        return true;
    }

    private Object invoke(String methodName, Class<?>[] parameterTypes, Object... args) throws Throwable {
        try {
            return ReflectionHelper.invokeMethodWithParam(
                    IUserManager.class,
                    userManager,
                    methodName,
                    parameterTypes,
                    args
            );
        } catch (InvocationTargetException exception) {
            throw unwrap(exception);
        }
    }

    private static JSONObject userInfoToJson(Object userInfo) throws Exception {
        JSONObject json = new JSONObject();
        json.put("id", readField(userInfo, "id"));
        json.put("name", nullable(readField(userInfo, "name")));
        json.put("flags", readField(userInfo, "flags"));
        json.put("user_type", nullable(readField(userInfo, "userType")));
        json.put("serial_number", readField(userInfo, "serialNumber"));
        json.put("profile_group_id", readField(userInfo, "profileGroupId"));
        json.put("partial", readField(userInfo, "partial"));
        json.put("pre_created", readField(userInfo, "preCreated"));
        return json;
    }

    private static Object readField(Object target, String fieldName) throws Exception {
        return ReflectionHelper.getField(target, fieldName);
    }

    private static Object nullable(Object value) {
        return value == null ? JSONObject.NULL : value;
    }

    private static int parseFlags(String value) {
        if (value == null || value.trim().isEmpty()) {
            return 0;
        }
        int result = 0;
        for (String token : value.split("[|,]")) {
            String trimmed = token.trim();
            if (!trimmed.isEmpty()) {
                result |= Integer.decode(trimmed);
            }
        }
        return result;
    }

    private static int parseRequiredInt(Map<String, String> params, String name) {
        return Integer.decode(require(params, name));
    }

    private static long parseLong(String value, long defaultValue) {
        return value == null || value.isEmpty() ? defaultValue : Long.decode(value);
    }

    private static boolean parseBoolean(String value, boolean defaultValue) {
        if (value == null || value.isEmpty()) {
            return defaultValue;
        }
        if ("1".equals(value) || "true".equalsIgnoreCase(value) || "yes".equalsIgnoreCase(value)) {
            return true;
        }
        if ("0".equals(value) || "false".equalsIgnoreCase(value) || "no".equalsIgnoreCase(value)) {
            return false;
        }
        throw new IllegalArgumentException("invalid boolean: " + value);
    }

    private static String[] parseStringList(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        List<String> result = new ArrayList<>();
        for (String item : value.split(",")) {
            String trimmed = item.trim();
            if (!trimmed.isEmpty()) {
                result.add(trimmed);
            }
        }
        return result.toArray(new String[0]);
    }

    private static String require(Map<String, String> params, String name) {
        String value = params.get(name);
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("missing parameter: " + name);
        }
        return value.trim();
    }

    private static NanoHTTPD.Response jsonResponse(NanoHTTPD.Response.Status status, JSONObject json) {
        return newFixedLengthResponse(status, MIME_JSON, json.toString());
    }

    private static NanoHTTPD.Response errorResponse(NanoHTTPD.Response.Status status, String message, Throwable throwable) {
        JSONObject json = new JSONObject();
        try {
            json.put("success", false);
            json.put("error", message);
            if (throwable != null) {
                json.put("exception", throwable.getClass().getName());
                json.put("detail", throwable.getMessage() == null ? JSONObject.NULL : throwable.getMessage());
            }
        } catch (Exception ignored) {
        }
        return jsonResponse(status, json);
    }

    private static Throwable unwrap(Throwable throwable) {
        Throwable current = throwable;
        while ((current instanceof InvocationTargetException || current instanceof ExceptionInInitializerError) && current.getCause() != null) {
            current = current.getCause();
        }
        return current;
    }
}
