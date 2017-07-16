package com.dialonce.sdk;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.LOG;
import org.json.JSONArray;
import org.json.JSONException;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.text.TextUtils;

import com.dialonce.sdk.DialOnce;

public class DialOnceBridge extends CordovaPlugin {

    private static final String TAG = "dial-once-cordova";
    private static final String[] permissions = { Manifest.permission.INTERNET,
            Manifest.permission.ACCESS_NETWORK_STATE,
            Manifest.permission.CALL_PHONE,
            Manifest.permission.PROCESS_OUTGOING_CALLS,
            Manifest.permission.READ_PHONE_STATE,
            Manifest.permission.VIBRATE,
            Manifest.permission.GET_TASKS,
            Manifest.permission.INSTALL_SHORTCUT };
    private static final int REQUEST_CODE_PERMISSION = 0;

    @Override 
    protected void pluginInitialize() {
        try {
            Context context = cordova.getActivity().getApplicationContext();
            ApplicationInfo applicationInfo = context.getPackageManager().getApplicationInfo(
                    context.getPackageName(), PackageManager.GET_META_DATA);

            String apiKey = applicationInfo.metaData.getString("DIAL_ONCE_API_KEY");

            if (TextUtils.isEmpty(apiKey)) {
                LOG.e(TAG, "ANDROID_API_KEY is empty. Have you set your ANDROID_API_KEY ?");
            } else {
                DialOnce.init(context, apiKey);
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !hasPermissions(permissions)) {
                LOG.i(TAG, "Make sure that you called `navigator.dialonce.requestPermissions()` later"
                        + " to grant all needed permissions");
            }
        } catch (Exception exception) {
            LOG.e(TAG, "Something went wrong when initializing DialOnce :", exception);
        }
    }

    @Override 
    public void onNewIntent(Intent intent) {
        cordova.getActivity().setIntent(intent);
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("requestPermissions")) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                public void run() {
                    requestPermissions();
                }
            });
        } else {
            return false;
        }

        callbackContext.success();
        return true;
    }

    private void requestPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!hasPermissions(permissions)) {
                cordova.requestPermissions(this, REQUEST_CODE_PERMISSION, permissions);
            }
        }
    }

    private boolean hasPermissions(String[] permissions) {
        for (String perm : permissions) {
            if (!cordova.hasPermission(perm)) {
                return false;
            }
        }

        return true;
    }
}
