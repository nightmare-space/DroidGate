package android.window;

import android.os.Parcel;
import android.os.Parcelable;

public final class WindowContainerTransaction implements Parcelable {
    public WindowContainerTransaction() {
    }

    public WindowContainerTransaction(Parcel in) {
    }

    public WindowContainerTransaction removeTask(WindowContainerToken containerToken) {
        throw new RuntimeException("STUB");
    }

    public WindowContainerTransaction setHidden(WindowContainerToken container, boolean hidden) {
        throw new RuntimeException("STUB");
    }

    public WindowContainerTransaction reparent(WindowContainerToken child,
                                               WindowContainerToken parent, boolean onTop) {
        throw new RuntimeException("STUB");
    }

    public static final Creator<WindowContainerTransaction> CREATOR = new Creator<WindowContainerTransaction>() {
        @Override
        public WindowContainerTransaction createFromParcel(Parcel in) {
            return new WindowContainerTransaction(in);
        }

        @Override
        public WindowContainerTransaction[] newArray(int size) {
            return new WindowContainerTransaction[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
    }
}