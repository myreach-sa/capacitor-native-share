package ch.rea.plugins.nativeshare;

import android.content.Intent;
import android.net.Uri;
import com.getcapacitor.JSObject;
import java.util.ArrayList;

public class NativeShare {

    protected JSObject[] handleSendIntent(Intent intent) {
        String mimeType = intent.getType();
        String text = intent.getStringExtra(Intent.EXTRA_TEXT);
        Uri uri = intent.getParcelableExtra(Intent.EXTRA_STREAM);

        String mimeTypeStr = mimeType != null ? mimeType : "";
        String uriStr = uri != null ? uri.toString() : "";
        String textStr = text != null ? text : "";

        JSObject item = new JSObject();
        item.put("mimeType", uriStr.equals("") ? "" : mimeTypeStr);
        item.put("text", textStr);
        item.put("uri", uriStr);

        return new JSObject[] { item };
    }

    protected JSObject[] handleSendMultipleIntent(Intent intent) {
        ArrayList<Uri> uriList = intent.getParcelableArrayListExtra(Intent.EXTRA_STREAM);
        int size = uriList.size();
        JSObject[] items = new JSObject[size];

		String mimeType = intent.getType();
		String mimeTypeStr = mimeType != null ? mimeType : "";

        for (int i = 0; i < size; i++) {
            Uri uri = uriList.get(i);
            JSObject item = new JSObject();
            item.put("mimeType", mimeTypeStr);
            item.put("text", "");
            item.put("uri", uri != null ? uri.toString() : "");
            items[i] = item;
        }

        return items;
    }
}
