package com.mob.flutter.mobpush.impl;

import android.content.Context;
import android.content.Intent;

import com.mob.flutter.mobpush.MobpushPlugin;
import com.mob.pushsdk.MobPush;
import com.mob.pushsdk.MobPushCustomMessage;
import com.mob.pushsdk.MobPushNotifyMessage;
import com.mob.pushsdk.MobPushReceiver;
import com.mob.pushsdk.MobPushUtils;
import com.mob.tools.utils.Hashon;

import org.json.JSONArray;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;

public class StreamHandlerImpl implements EventChannel.StreamHandler, OnRemoveReceiverListener{
    private static MobPushReceiver mobPushReceiver;

    private Hashon hashon = new Hashon();

    EventChannel.EventSink eventSink;

    MobpushPlugin mobpushPlugin;

    public StreamHandlerImpl(MobpushPlugin mobpushPlugin) {
        this.mobpushPlugin = mobpushPlugin;
    }

    private MobPushReceiver createMobPushReceiver() {
        mobPushReceiver = new MobPushReceiver() {
            @Override
            public void onCustomMessageReceive(Context context, MobPushCustomMessage mobPushCustomMessage) {
                HashMap<String, Object> map = new HashMap<>();
                map.put("action", 0);
                map.put("result", hashon.fromJson(hashon.fromObject(mobPushCustomMessage)));
                eventSink.success(hashon.fromHashMap(map));
            }

            @Override
            public void onNotifyMessageReceive(Context context, MobPushNotifyMessage mobPushNotifyMessage) {
                HashMap<String, Object> map = new HashMap<>();
                map.put("action", 1);
                map.put("result", hashon.fromJson(hashon.fromObject(mobPushNotifyMessage)));
                eventSink.success(hashon.fromHashMap(map));
            }

            @Override
            public void onNotifyMessageOpenedReceive(Context context, MobPushNotifyMessage mobPushNotifyMessage) {
                HashMap<String, Object> map = new HashMap<>();
                map.put("action", 2);
                map.put("result", hashon.fromJson(hashon.fromObject(mobPushNotifyMessage)));
                eventSink.success(hashon.fromHashMap(map));
            }

            @Override
            public void onTagsCallback(Context context, String[] tags, int operation, int errorCode) {

            }

            @Override
            public void onAliasCallback(Context context, String alias, int operation, int errorCode) {

            }
        };
        return mobPushReceiver;
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
        mobPushReceiver = createMobPushReceiver();
        MobPush.addPushReceiver(mobPushReceiver);
        consumeIntent();
    }

    @Override
    public void onCancel(Object o) {

    }

    @Override
    public void onRemoveReceiver() {
        Log.e("", "onRemoveReceiver");
        if (mobPushReceiver != null) {
            MobPush.removePushReceiver(mobPushReceiver);
        }
    }


    public void consumeIntent() {
        android.util.Log.d("| MainActivity | - ", "dealPushResponse: 3");
        if (this.mobpushPlugin.mainActivity != null) {
            android.util.Log.d("| MainActivity | - ", "dealPushResponse: 4");
            Intent intent = this.mobpushPlugin.mainActivity.getIntent();
            if (intent != null) {
                android.util.Log.d("| MainActivity | - ", "dealPushResponse: 5");
                MobPush.notificationClickAck(intent);
                JSONArray parseMainPluginPushIntent = MobPushUtils.parseMainPluginPushIntent(intent);
                HashMap<String, Object> map = new HashMap<>();
                map.put("action", 3);
                map.put("result", hashon.fromJson(hashon.fromObject(parseMainPluginPushIntent)));
                if(eventSink != null) {
                    eventSink.success(hashon.fromHashMap(map));
                }
            }
        }
    }
}
