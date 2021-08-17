package ch.rea.plugins.nativeshare;

import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;

import com.getcapacitor.JSObject;
import com.getcapacitor.Logger;

import java.util.ArrayList;

public class NativeShare {

    public static JSObject[] handleSendIntent(Context context, Intent intent) {
        String text = intent.getStringExtra(Intent.EXTRA_TEXT);
        Uri uri = intent.getParcelableExtra(Intent.EXTRA_STREAM);

		String uriStr = uri != null ? uri.toString() : "";
		String textStr = text != null ? text : "";

		String mimeType = NativeShare.mimeTypeFromURI(context, uriStr);

        JSObject item = new JSObject();
        item.put("mimeType", mimeType);
        item.put("text", textStr);
        item.put("uri", uriStr);

        return new JSObject[] { item };
    }

    public static JSObject[] handleSendMultipleIntent(Context context, Intent intent) {
        ArrayList<Uri> uriList = intent.getParcelableArrayListExtra(Intent.EXTRA_STREAM);
        int size = uriList.size();
        JSObject[] items = new JSObject[size];

        for (int i = 0; i < size; i++) {
            Uri uri = uriList.get(i);
            String uriStr = uri != null ? uri.toString() : "";

			String mimeType = NativeShare.mimeTypeFromURI(context, uriStr);

            JSObject item = new JSObject();
            item.put("mimeType", mimeType);
            item.put("text", "");
            item.put("uri", uriStr);
            items[i] = item;
        }

        return items;
    }

	public static String mimeTypeFromURI(Context context, String uriPath) {
		try {
			Uri uri = Uri.parse(uriPath);
			ContentResolver cR = context.getContentResolver();
			return cR.getType(uri);
		} catch (Exception e) {
			Logger.error("mimeTypeFromUri", e);
			return "";
		}
	}
}
