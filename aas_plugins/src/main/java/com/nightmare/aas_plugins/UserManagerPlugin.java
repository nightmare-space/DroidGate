package com.nightmare.aas_plugins;

import static fi.iki.elonen.NanoHTTPD.newFixedLengthResponse;

import android.content.Context;
import android.os.IBinder;
import android.os.ServiceManager;

import com.nightmare.aas.foundation.AndroidAPIPlugin;

import org.json.JSONArray;
import org.json.JSONObject;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
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
public class UserManagerPlugin extends AndroidAPIPlugin {
    private static final String MIME_JSON = "application/json";
    private static final String CLONE_PROFILE_TYPE = "android.os.usertype.profile.CLONE";
    private static final long DEFAULT_WAIT_TIMEOUT_MS = 30_000L;
    private static final long MAX_WAIT_TIMEOUT_MS = 120_000L;

    private final Class<?> userManagerInterface;
    private final Object userManager;
    private final Throwable initializationError;

    public UserManagerPlugin() {
        Class<?> resolvedInterface = null;
        Object resolvedManager = null;
        Throwable error = null;
        try {
            IBinder binder = ServiceManager.getService(Context.USER_SERVICE);
            if (binder == null) {
                throw new IllegalStateException("UserManager binder is unavailable");
            }
            Class<?> stubClass = Class.forName("android.os.IUserManager$Stub");
            resolvedInterface = Class.forName("android.os.IUserManager");
            resolvedManager = stubClass.getMethod("asInterface", IBinder.class).invoke(null, binder);
        } catch (Throwable throwable) {
            error = unwrap(throwable);
        }
        userManagerInterface = resolvedInterface;
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

        Map<String, String> params = session.getParms();
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
                case "remove_clone_profile":
                    return removeCloneProfile(params);
                case "stop_clone_profile":
                    return stopCloneProfile(params);
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

    private NanoHTTPD.Response createUser(Map<String, String> params) throws Throwable {
        String name = require(params, "name");
        String userType = params.get("userType");
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
        String userType = params.get("userType");
        if (userType == null || userType.isEmpty()) {
            userType = CLONE_PROFILE_TYPE;
        }
        int flags = parseFlags(params.get("flags"));
        int parentUserId = parseRequiredInt(params, "parentUserId");
        String[] disallowedPackages = parseStringList(params.get("disallowedPackages"));
        boolean evenWhenDisallowed = parseBoolean(params.get("evenWhenDisallowed"), false);
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
        String userType = require(params, "userType");
        Object userInfo = invoke("preCreateUserWithThrow", new Class<?>[]{String.class}, userType);
        return userResult("pre_create_user", userInfo);
    }

    private NanoHTTPD.Response removeCloneProfile(Map<String, String> params) throws Throwable {
        int userId = parseRequiredInt(params, "userId");
        int confirmUserId = parseRequiredInt(params, "confirmUserId");
        if (userId != confirmUserId) {
            throw new IllegalArgumentException("confirmUserId must equal userId");
        }
        if (userId == 0) {
            throw new IllegalArgumentException("system user 0 cannot be removed");
        }

        Object userInfo = getUserInfo(userId);
        if (userInfo == null) {
            throw new IllegalArgumentException("user does not exist: " + userId);
        }
        String userType = String.valueOf(readField(userInfo, "userType"));
        if (!CLONE_PROFILE_TYPE.equals(userType)) {
            throw new IllegalArgumentException("refusing to remove non-clone user " + userId + " of type " + userType);
        }

        String mode = params.get("mode");
        if (mode == null || mode.isEmpty()) {
            mode = "normal";
        }

        JSONObject json = new JSONObject();
        json.put("action", "remove_clone_profile");
        json.put("userId", userId);
        json.put("mode", mode);
        json.put("userBeforeRemoval", userInfoToJson(userInfo));

        boolean accepted;
        if ("normal".equals(mode)) {
            accepted = (Boolean) invoke("removeUser", new Class<?>[]{int.class}, userId);
            json.put("binderResult", accepted);
        } else if ("when_possible".equals(mode)) {
            int result = (Integer) invoke(
                    "removeUserWhenPossible",
                    new Class<?>[]{int.class, boolean.class},
                    userId,
                    false
            );
            accepted = result == 0 || result == 1 || result == 2;
            json.put("binderResult", result);
            json.put("overrideDevicePolicy", false);
        } else {
            throw new IllegalArgumentException("unknown remove mode: " + mode);
        }

        boolean wait = parseBoolean(params.get("wait"), false);
        json.put("accepted", accepted);
        json.put("wait", wait);
        if (accepted && wait) {
            long timeoutMs = parseLong(params.get("timeoutMs"), DEFAULT_WAIT_TIMEOUT_MS);
            timeoutMs = Math.max(0L, Math.min(timeoutMs, MAX_WAIT_TIMEOUT_MS));
            json.put("removed", waitUntilRemoved(userId, timeoutMs));
            json.put("timeoutMs", timeoutMs);
        } else {
            json.put("removed", getUserInfo(userId) == null);
        }
        json.put("success", accepted);
        return jsonResponse(NanoHTTPD.Response.Status.OK, json);
    }

    private NanoHTTPD.Response stopCloneProfile(Map<String, String> params) throws Throwable {
        int userId = parseRequiredInt(params, "userId");
        if (userId == 0) {
            throw new IllegalArgumentException("system user 0 cannot be stopped");
        }

        Object userInfo = getUserInfo(userId);
        if (userInfo == null) {
            throw new IllegalArgumentException("user does not exist: " + userId);
        }
        String userType = String.valueOf(readField(userInfo, "userType"));
        if (!CLONE_PROFILE_TYPE.equals(userType)) {
            throw new IllegalArgumentException("refusing to stop non-clone user " + userId + " of type " + userType);
        }

        IBinder binder = ServiceManager.getService(Context.ACTIVITY_SERVICE);
        if (binder == null) {
            throw new IllegalStateException("ActivityManager binder is unavailable");
        }
        Class<?> stubClass = Class.forName("android.app.IActivityManager$Stub");
        Class<?> activityManagerInterface = Class.forName("android.app.IActivityManager");
        Object activityManager = stubClass.getMethod("asInterface", IBinder.class).invoke(null, binder);

        Object binderResult;
        try {
            Method method = activityManagerInterface.getMethod("stopProfile", int.class);
            binderResult = method.invoke(activityManager, userId);
        } catch (InvocationTargetException exception) {
            throw unwrap(exception);
        }

        JSONObject json = new JSONObject();
        json.put("success", true);
        json.put("action", "stop_clone_profile");
        json.put("userId", userId);
        json.put("binderResult", binderResult == null ? JSONObject.NULL : binderResult);
        json.put("user", userInfoToJson(userInfo));
        return jsonResponse(NanoHTTPD.Response.Status.OK, json);
    }

    private NanoHTTPD.Response getUser(Map<String, String> params) throws Throwable {
        int userId = parseRequiredInt(params, "userId");
        Object userInfo = getUserInfo(userId);
        JSONObject json = new JSONObject();
        json.put("success", true);
        json.put("action", "get_user");
        json.put("userId", userId);
        json.put("exists", userInfo != null);
        json.put("user", userInfo == null ? JSONObject.NULL : userInfoToJson(userInfo));
        return jsonResponse(NanoHTTPD.Response.Status.OK, json);
    }

    private NanoHTTPD.Response getUsers(Map<String, String> params) throws Throwable {
        boolean excludePartial = parseBoolean(params.get("excludePartial"), true);
        boolean excludeDying = parseBoolean(params.get("excludeDying"), false);
        boolean excludePreCreated = parseBoolean(params.get("excludePreCreated"), true);
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
                    users.put(userInfoToJson(userInfo));
                }
            }
        }

        JSONObject json = new JSONObject();
        json.put("success", true);
        json.put("action", "get_users");
        json.put("excludePartial", excludePartial);
        json.put("excludeDying", excludeDying);
        json.put("excludePreCreated", excludePreCreated);
        json.put("count", users.length());
        json.put("users", users);
        return jsonResponse(NanoHTTPD.Response.Status.OK, json);
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
            Method method = userManagerInterface.getMethod(methodName, parameterTypes);
            return method.invoke(userManager, args);
        } catch (InvocationTargetException exception) {
            throw unwrap(exception);
        }
    }

    private static JSONObject userInfoToJson(Object userInfo) throws Exception {
        JSONObject json = new JSONObject();
        json.put("id", readField(userInfo, "id"));
        json.put("name", nullable(readField(userInfo, "name")));
        json.put("flags", readField(userInfo, "flags"));
        json.put("userType", nullable(readField(userInfo, "userType")));
        json.put("serialNumber", readField(userInfo, "serialNumber"));
        json.put("profileGroupId", readField(userInfo, "profileGroupId"));
        json.put("partial", readField(userInfo, "partial"));
        json.put("preCreated", readField(userInfo, "preCreated"));
        return json;
    }

    private static Object readField(Object target, String fieldName) throws Exception {
        Field field = target.getClass().getField(fieldName);
        return field.get(target);
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
