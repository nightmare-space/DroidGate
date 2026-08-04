package android.app;

import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.RemoteException;

public interface IAppTask extends IInterface {
    void setExcludeFromRecents(boolean exclude) throws RemoteException;

    ActivityManager.RecentTaskInfo getTaskInfo() throws RemoteException;

    abstract class Stub extends Binder {
        public static IAppTask asInterface(IBinder obj) {
            throw new RuntimeException("STUB");
        }
    }
}
