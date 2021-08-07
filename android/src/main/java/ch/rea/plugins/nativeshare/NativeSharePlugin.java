package ch.rea.plugins.nativeshare;

import android.content.Intent;
import android.util.Log;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(
    name = "NativeShare"
)
public class NativeSharePlugin extends Plugin {

    private final NativeShare implementation = new NativeShare();

    @PluginMethod
    public void getSharedItems(PluginCall call) {
        JSObject ret = implementation.getSharedItems();
        call.resolve(ret);
    }

    @Override
    protected void handleOnNewIntent(Intent intent) {
        String action = intent.getAction();
        Log.d("Intent", action);
    }
}
