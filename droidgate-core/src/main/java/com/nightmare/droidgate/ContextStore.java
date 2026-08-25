package com.nightmare.droidgate;

import android.annotation.SuppressLint;
import android.content.Context;

public class ContextStore {
    @SuppressLint("StaticFieldLeak")
    private static final ContextStore INSTANCE = new ContextStore();

    private ContextStore() {
    }

    public static ContextStore getInstance() {
        return INSTANCE;
    }

    private Context context;
    private boolean embededMode;

    public void setContext(Context context) {
        this.context = context;
    }

    public void setEmbededMode(boolean embededMode) {
        this.embededMode = embededMode;
    }

    static public Context getContext() {
        return INSTANCE.context;
    }

    static public boolean isEmbededMode() {
        return INSTANCE.embededMode;
    }

}
