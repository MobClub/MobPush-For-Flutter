package com.mob.flutter.mobpush;

import androidx.annotation.NonNull;

import com.mob.MobSDK;
import com.mob.commons.MOBPUSH;
import com.mob.flutter.mobpush.impl.MethodCallHandlerImpl;
import com.mob.flutter.mobpush.impl.StreamHandlerImpl;


import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MobpushPlugin implements FlutterPlugin {

    private MethodChannel methodChannel;
    private MethodChannel.MethodCallHandler methodCallHandler;
    private EventChannel eventChannel;
    private EventChannel.StreamHandler streamHandler;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        try {
	        MobSDK.setChannel(new MOBPUSH(), MobSDK.CHANNEL_FLUTTER);
            methodChannel = new MethodChannel(binding.getBinaryMessenger(), "mob.com/mobpush_plugin");
            MethodCallHandlerImpl methodCallHandlerImpl = new MethodCallHandlerImpl();
            methodCallHandler = methodCallHandlerImpl;
            methodChannel.setMethodCallHandler(methodCallHandler);

            eventChannel = new EventChannel(binding.getBinaryMessenger(), "mobpush_receiver");
            StreamHandlerImpl streamHandlerImpl = new StreamHandlerImpl();
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
}
