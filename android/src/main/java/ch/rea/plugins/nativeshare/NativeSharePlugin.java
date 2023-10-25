package ch.rea.plugins.nativeshare;

import android.content.Intent;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import org.json.JSONException;

@CapacitorPlugin(name = "NativeShare")
public class NativeSharePlugin extends Plugin {

    private JSObject lastSharedItems = null;

    @PluginMethod
    public void getLastSharedItems(PluginCall call) {
        if (this.lastSharedItems != null) {
            JSObject options = call.getObject("options");
            boolean autoremove = false;
            try {
                if (options != null) {
                    autoremove = options.getBoolean("autoremove");
                }
            } catch (JSONException ignored) {}

            if (autoremove) {
                this.lastSharedItems = null;
            }

            call.resolve(this.lastSharedItems);
        } else {
            call.reject("No shared detected");
        }
    }

    @PluginMethod
    public void clear(PluginCall call) {
        this.lastSharedItems = null;
        call.resolve(new JSObject());
    }

    @Override
    protected void handleOnNewIntent(Intent intent) {
        String action = intent.getAction();
        switch (action) {
            case Intent.ACTION_SEND:
                this.notifyEvent(NativeShare.handleSendIntent(this.getContext(), intent));
                break;
            case Intent.ACTION_SEND_MULTIPLE:
                this.notifyEvent(NativeShare.handleSendMultipleIntent(this.getContext(), intent));
                break;
        }
    }

    protected void notifyEvent(JSObject[] items) {
        int length = items.length;
        JSObject notification = new JSObject();
        JSObject itemsSend = new JSObject();
        for (int i = 0; i < length; i++) {
            itemsSend.put("" + i, items[i]);
        }
        notification.put("length", length);
        notification.put("items", itemsSend);
        notifyListeners("sharedReceived", notification);

        this.lastSharedItems = notification;
    }
}
