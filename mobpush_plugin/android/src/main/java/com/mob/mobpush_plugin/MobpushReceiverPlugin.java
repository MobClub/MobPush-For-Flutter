package com.mob.mobpush_plugin;

import android.content.Context;
import androidx.annotation.NonNull;

import com.mob.pushsdk.MobPush;
import com.mob.pushsdk.MobPushCustomMessage;
import com.mob.pushsdk.MobPushNotifyMessage;
import com.mob.pushsdk.MobPushReceiver;
import com.mob.tools.utils.Hashon;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MobpushReceiverPlugin implements EventChannel.StreamHandler {
    private MobpushPlugin mobpushPlugin;

    private MobPushReceiver baseMobPushReceiver;
    MobPushReceiver mobPushReceiver;

    private EventChannel eventChannel;

    private Hashon hashon = new Hashon();

    MobpushReceiverPlugin(MobpushPlugin mobpushPlugin, @NonNull BinaryMessenger messenger) {
        this.mobpushPlugin = mobpushPlugin;
        eventChannel = new EventChannel(messenger, "mobpush_receiver");
        eventChannel.setStreamHandler(this);
        createBaseMobPushReceiver();
        MobPush.addPushReceiver(baseMobPushReceiver);
    }


    private void createBaseMobPushReceiver() {
        baseMobPushReceiver = new MobPushReceiver() {
            @Override
            public void onCustomMessageReceive(Context context, MobPushCustomMessage mobPushCustomMessage) {

            }

            @Override
            public void onNotifyMessageReceive(Context context, MobPushNotifyMessage mobPushNotifyMessage) {

            }

            @Override
            public void onNotifyMessageOpenedReceive(Context context, MobPushNotifyMessage mobPushNotifyMessage) {

            }

            @Override
            public void onTagsCallback(Context context, String[] tags, int operation, int errorCode) {
                HashMap<String, Object> map = new HashMap<String, Object>();
                MethodChannel.Result result = null;
                // 0 获取， 1 设置， 2 删除，3 清空
                switch (operation) {
                    case 0:
                        result = mobpushPlugin.getTagsCallback.remove(0);
                        map.put("res", tags == null ? new ArrayList<String>() : Arrays.asList(tags));
                        map.put("error", "");
                        map.put("errorCode", String.valueOf(errorCode));
                        break;
                    case 1:
                        result = mobpushPlugin.addTagsCallback.remove(0);
                        map.put("res", errorCode == 0 ? "success" : "failed");
                        map.put("error", "");
                        map.put("errorCode", String.valueOf(errorCode));
                        break;
                    case 2:
                        result = mobpushPlugin.deleteTagsCallback.remove(0);
                        map.put("res", errorCode == 0 ? "success" : "failed");
                        map.put("error", "");
                        map.put("errorCode", String.valueOf(errorCode));
                        break;
                    case 3:
                        result = mobpushPlugin.cleanTagsCallback.remove(0);
                        map.put("res", errorCode == 0 ? "success" : "failed");
                        map.put("error", "");
                        map.put("errorCode", String.valueOf(errorCode));
                        break;
                }
                if (result != null) {
                    result.success(map);
                }
            }

            @Override
            public void onAliasCallback(Context context, String alias, int operation, int errorCode) {
                HashMap<String, Object> map = new HashMap<String, Object>();
                MethodChannel.Result result = null;
                // 0 获取， 1 设置， 2 删除
                switch (operation) {
                    case 0:
                        result = mobpushPlugin.getAliasCallback.remove(0);
                        map.put("res", alias);
                        map.put("error", "");
                        map.put("errorCode", String.valueOf(errorCode));
                        break;
                    case 1:
                        result = mobpushPlugin.setAliasCallback.remove(0);
                        map.put("res", errorCode == 0 ? "success" : "failed");
                        map.put("error", "");
                        map.put("errorCode", String.valueOf(errorCode));
                        break;
                    case 2:
                        result = mobpushPlugin.deleteAliasCallback.remove(0);
                        map.put("res", errorCode == 0 ? "success" : "failed");
                        map.put("error", "");
                        map.put("errorCode", String.valueOf(errorCode));
                        break;
                }
                if (result != null) {
                    result.success(map);
                }
            }
        };
    }


    private void createMobPushReceiver(final EventChannel.EventSink event) {
        mobPushReceiver = new MobPushReceiver() {
            @Override
            public void onCustomMessageReceive(Context context, MobPushCustomMessage mobPushCustomMessage) {
                HashMap<String, Object> map = new HashMap<String, Object>();
                map.put("action", 0);
                map.put("result", hashon.fromJson(hashon.fromObject(mobPushCustomMessage)));
                event.success(hashon.fromHashMap(map));
            }

            @Override
            public void onNotifyMessageReceive(Context context, MobPushNotifyMessage mobPushNotifyMessage) {
                HashMap<String, Object> map = new HashMap<String, Object>();
                map.put("action", 1);
                map.put("result", hashon.fromJson(hashon.fromObject(mobPushNotifyMessage)));
                event.success(hashon.fromHashMap(map));
            }

            @Override
            public void onNotifyMessageOpenedReceive(Context context, MobPushNotifyMessage mobPushNotifyMessage) {
                HashMap<String, Object> map = new HashMap<String, Object>();
                map.put("action", 2);
                map.put("result", hashon.fromJson(hashon.fromObject(mobPushNotifyMessage)));
                event.success(hashon.fromHashMap(map));
            }

            @Override
            public void onTagsCallback(Context context, String[] tags, int operation, int errorCode) {

            }

            @Override
            public void onAliasCallback(Context context, String alias, int operation, int errorCode) {

            }
        };
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        createMobPushReceiver(eventSink);
        MobPush.addPushReceiver(mobPushReceiver);
    }

    @Override
    public void onCancel(Object o) {
        MobPush.removePushReceiver(mobPushReceiver);
        mobPushReceiver = null;
    }


    void onDestroy() {
        if(mobPushReceiver!=null){
            MobPush.removePushReceiver(mobPushReceiver);
            mobPushReceiver = null;
        }
        MobPush.removePushReceiver(baseMobPushReceiver);
        baseMobPushReceiver = null;
        eventChannel.setStreamHandler(null);
        eventChannel = null;
    }
}
