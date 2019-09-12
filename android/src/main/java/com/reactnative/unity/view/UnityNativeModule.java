package com.reactnative.unity.view;

import android.app.Activity;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.modules.core.DeviceEventManagerModule;

public class UnityNativeModule extends ReactContextBaseJavaModule implements UnityEventListener {

    public UnityNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
        UnityUtils.addUnityEventListener(this);
    }

    @Override
    public String getName() {
        return "UnityNativeModule";
    }

    @ReactMethod
    public void isReady(Promise promise) {
        for (int i = 0; i < 5; i++) {
            if (UnityUtils.isUnityReady()) {
                promise.resolve(true);
                return;
            }
            try {
                Thread.sleep(200L);
            } catch (Exception e) {
                // sux to be us
            }
        }
        promise.resolve(false);
    }

    /** 
    *   Tries to get the current activity in a safe way. Due to a bug in RN getCurrentActivity can return null if called from componentDidMount.
    *   See https://github.com/facebook/react-native/issues/18345
    *   The issue was easy to reproduce by exiting the app by pressing back button on android backing out of app and the restarting it.    
    */
    public Activity getCurrentActivitySafe() {
        for (int i = 0; i < 10; i++) {
            Activity activity = getCurrentActivity();          
            if(activity != null) {
                return activity;
            }          
            try {
                Thread.sleep(200L);
            } catch (Exception e) {
            }
        }
        return null;
    }

    @ReactMethod
    public void createUnity(final Promise promise) {
        UnityUtils.createPlayer(getCurrentActivitySafe(), new UnityUtils.CreateCallback() {
            @Override
            public void onReady() {
                promise.resolve(true);
            }
        });
    }

    @ReactMethod
    public void postMessage(String gameObject, String methodName, String message) {
        UnityUtils.postMessage(gameObject, methodName, message);
    }

    @ReactMethod
    public void pause() {
        UnityUtils.pause();
    }

    @ReactMethod
    public void resume() {
        UnityUtils.resume();
    }

    @Override
    public void onMessage(String message) {
        ReactContext context = getReactApplicationContext();
        context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("onUnityMessage", message);
    }
}
