package com.mob.flutter.mobpush;

import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;

import com.mob.MobSDK;
import com.mob.commons.MOBPUSH;
import com.mob.flutter.mobpush.impl.MethodCallHandlerImpl;
import com.mob.flutter.mobpush.impl.StreamHandlerImpl;


import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MobpushPlugin implements FlutterPlugin, ActivityAware {

    private MethodChannel methodChannel;
    private MethodChannel.MethodCallHandler methodCallHandler;
    private EventChannel eventChannel;
    private StreamHandlerImpl streamHandler;
    public Activity mainActivity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        try {
            MobSDK.setChannel(new MOBPUSH(), MobSDK.CHANNEL_FLUTTER);
            methodChannel = new MethodChannel(binding.getBinaryMessenger(), "mob.com/mobpush_plugin");
            MethodCallHandlerImpl methodCallHandlerImpl = new MethodCallHandlerImpl();
            methodCallHandler = methodCallHandlerImpl;
            methodChannel.setMethodCallHandler(methodCallHandler);

            eventChannel = new EventChannel(binding.getBinaryMessenger(), "mobpush_receiver");
            StreamHandlerImpl streamHandlerImpl = new StreamHandlerImpl(this);
            streamHandler = streamHandlerImpl;
            eventChannel.setStreamHandler(streamHandler);

            methodCallHandlerImpl.setRemoveReceiverListener(streamHandlerImpl);
        } catch (Exception e) {

        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        try {
            methodChannel.setMethodCallHandler(null);
            eventChannel.setStreamHandler(null);
        } catch (Exception e) {

        }
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.mainActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }

    public static void dealPushResponse(FlutterEngine flutterEngine) {
        FlutterPlugin flutterPlugin = flutterEngine.getPlugins().get(MobpushPlugin.class);
        Log.d("| MainActivity | - ", "dealPushResponse: 1");
        if (flutterPlugin != null) {
            Log.d("| MainActivity | - ", "dealPushResponse: 2");
            ((MobpushPlugin) flutterPlugin).streamHandler.consumeIntent();
        }
    }
}
