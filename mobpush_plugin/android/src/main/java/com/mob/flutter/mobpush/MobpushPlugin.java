package com.mob.flutter.mobpush;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.mob.MobSDK;
import com.mob.commons.MOBPUSH;
import com.mob.flutter.mobpush.impl.MethodCallHandlerImpl;
import com.mob.flutter.mobpush.impl.StreamHandlerImpl;
import com.mob.pushsdk.MobPushUtils;


import org.json.JSONArray;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class MobpushPlugin implements FlutterPlugin, ActivityAware, PluginRegistry.NewIntentListener {

    private MethodChannel methodChannel;
    private MethodChannel.MethodCallHandler methodCallHandler;
    private EventChannel eventChannel;
    private StreamHandlerImpl streamHandler;
    public Activity mainActivity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        try {
            new Thread() {
                @Override
                public void run() {
                    super.run();
                    try {
                        MobSDK.setChannel(new MOBPUSH(), MobSDK.CHANNEL_FLUTTER);
                    } catch (Throwable throwable) {

                    }
                }
            }.start();
            // 标准: MethodChannel 统一命名：com.mob.项目xx.功能
            methodChannel = new MethodChannel(binding.getBinaryMessenger(), "com.mob.mobpush.methodChannel");
            MethodCallHandlerImpl methodCallHandlerImpl = new MethodCallHandlerImpl();
            methodCallHandler = methodCallHandlerImpl;
            methodChannel.setMethodCallHandler(methodCallHandler);

            eventChannel = new EventChannel(binding.getBinaryMessenger(), "com.mob.mobpush.reciever");
            streamHandler = new StreamHandlerImpl(this);
            eventChannel.setStreamHandler(streamHandler);

            methodCallHandlerImpl.setRemoveReceiverListener(streamHandler);
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
        binding.addOnNewIntentListener(this);
        this.mainActivity = binding.getActivity();

        if (mainActivity.getIntent() == null) {
            return;
        }

        final int flag = Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY;
        if ((mainActivity.getIntent().getFlags() & flag) != flag) {
            onNewIntent(mainActivity.getIntent());
        }
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        binding.addOnNewIntentListener(this);
        this.mainActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        this.mainActivity = null;
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        this.mainActivity = null;
    }

    @Override
    public boolean onNewIntent(@NonNull Intent intent) {
        if (handleIntent(intent)) {
            mainActivity.setIntent(intent);
            streamHandler.consumeIntent();
            return true;
        }

        return false;
    }

    private boolean handleIntent(Intent intent) {
        if (intent == null) {
            return false;
        }
        JSONArray var = MobPushUtils.parseSchemePluginPushIntent(intent);
        return var != null && var.length() > 0;
    }

}
