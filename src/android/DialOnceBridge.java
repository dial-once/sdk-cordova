package com.dialonce.sdk;

import org.apache.cordova.CordovaPlugin;
import org.json.JSONException;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;

import com.dialonce.sdk.DialOnce;

public class DialOnceBridge extends CordovaPlugin {

    String [] permissions = { Manifest.permission.INTERNET,
            Manifest.permission.ACCESS_NETWORK_STATE,
            Manifest.permission.CALL_PHONE,
            Manifest.permission.PROCESS_OUTGOING_CALLS,
            Manifest.permission.READ_PHONE_STATE,
            Manifest.permission.VIBRATE,
            Manifest.permission.GET_TASKS,
            Manifest.permission.INSTALL_SHORTCUT };
    private static int REQUEST_CODE_PERMISSION = 0;

    @Override protected void pluginInitialize() {
        this.initDialOnce();
    }

    @Override public void onStart() {
        //We also initialize Dial Once here just in case it has died. If Dial Once is already set up, this won't do anything.
        this.initDialOnce();
    }

    @Override public void onNewIntent(Intent intent) {
        cordova.getActivity().setIntent(intent);
    }

    private void initDialOnce() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!hasPermissions(permissions)) {
                cordova.requestPermissions(this, REQUEST_CODE_PERMISSION, permissions);
            }
        }
    }

    @Override
    public void onRequestPermissionResult(int requestCode, String[] permissions, int[] grantResults) throws JSONException {
        super.onRequestPermissionResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_CODE_PERMISSION) {
            for (int r : grantResults) {
                if (r == PackageManager.PERMISSION_DENIED) {
                    return;
                }
            }
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        Context context = cordova.getActivity().getApplicationContext();
                        ApplicationInfo applicationInfo = context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);

                        DialOnce.init(context, applicationInfo.metaData.getString("DIALONCE_API_KEY"));
                    } catch (Exception exception) {
                        System.err.println("[dialonce-cordova] Something went wrong when initializing DialOnce: " + exception.getMessage());
                        System.err.println("[dialonce-cordova] Have you set your ANDROID_API_KEY ?");
                    }
                }
            });
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
