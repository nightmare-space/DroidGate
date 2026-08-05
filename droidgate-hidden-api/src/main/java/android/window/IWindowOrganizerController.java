package android.window;

import android.os.IInterface;

public interface IWindowOrganizerController extends IInterface {

    void applyTransaction(WindowContainerTransaction t);
}