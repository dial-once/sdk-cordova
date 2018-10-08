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
    private static final String ANDROID_API_KEY_PLACEHOLDER = "_";
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

            if (TextUtils.isEmpty(apiKey) || ANDROID_API_KEY_PLACEHOLDER.equals(apiKey)) {
                LOG.w(TAG, "ANDROID_API_KEY is empty");
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

    /**
     * @brief 'main' method to call DialOnce SDK API
     * @details see https://cordova.apache.org/docs/en/latest/guide/platforms/android/plugin.html#threading
     * 
     * @param action method name
     * @param JSONArray arguments
     * @param CallbackContext to show execution result
     * @return true if method wasn't found
     */
    @Override
    public boolean execute(String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        switch (action) {
            case "init": {
                    final String apiKey = args.getString(0);
                    cordova.getActivity().runOnUiThread(new Runnable() {
                        public void run() {
                            try {
                                boolean displayInterstitial = args.optBoolean(1, false);
                                DialOnce.init(cordova.getActivity(), apiKey, displayInterstitial);
                                callbackContext.success();
                            } catch (Exception e) {
                                LOG.e(TAG, "Something went wrong during DialOnce.init : " + e.getMessage(), e);
                            }
                        }
                    });
                } 
                break;
            case "requestPermissions":
                cordova.getActivity().runOnUiThread(new Runnable() {
                    public void run() {
                        DialOnce.requestPermissions(cordova.getActivity());
                        callbackContext.success();
                    }
                });
                break;
            case "setEnableCallInterception": {
                    boolean enabled = args.getBoolean(0);
                    DialOnce.setEnableCallInterception(enabled);
                    callbackContext.success();
                }
                break;

            case "setDebug": {
                    final boolean enabled = args.getBoolean(0);
                    cordova.getActivity().runOnUiThread(new Runnable() {
                        public void run() {
                            try {
                                DialOnce.setDebug(enabled);
                                callbackContext.success();
                            } catch (Exception e) {
                                LOG.e(TAG, "Something went wrong during DialOnce.setDebug : " + e.getMessage(), e);
                            }
                        }
                    });
                }
                break;
            default:
                return false;
        }

        return true;
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
