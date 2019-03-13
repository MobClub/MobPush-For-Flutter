package com.mob.mobpush;

import android.content.Context;

import com.mob.mobpush.req.SimulateRequest;
import com.mob.pushsdk.MobPush;
import com.mob.pushsdk.MobPushCallback;
import com.mob.pushsdk.MobPushCustomMessage;
import com.mob.pushsdk.MobPushNotifyMessage;
import com.mob.pushsdk.MobPushReceiver;
import com.mob.tools.utils.Hashon;

import java.util.Arrays;
import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * MobpushPlugin
 */
public class MobpushReceiverPlugin implements EventChannel.StreamHandler {
    private Hashon hashon = new Hashon();

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        System.out.println(">>>>>>>>>>>>>registerWith");
        final EventChannel channel = new EventChannel(registrar.messenger(), "mobpush_receiver");
        channel.setStreamHandler(new MobpushReceiverPlugin());
    }

    private MobPushReceiver createMobPushReceiver(final EventChannel.EventSink event) {
        return new MobPushReceiver() {
            @Override
            public void onCustomMessageReceive(Context context, MobPushCustomMessage mobPushCustomMessage) {
                System.out.println(">>>>>>>>>>>>>>>>>>>>onCustomMessageReceive>>>>>>" + hashon.fromObject(mobPushCustomMessage));
                HashMap<String, Object> map = new HashMap<String, Object>();
                map.put("action", 0);
                map.put("result", hashon.fromObject(mobPushCustomMessage));
                event.success(hashon.fromHashMap(map));
            }

            @Override
            public void onNotifyMessageReceive(Context context, MobPushNotifyMessage mobPushNotifyMessage) {
                System.out.println(">>>>>>>>>>>>>>>>>>>>onNotifyMessageReceive>>>>>>" + hashon.fromObject(mobPushNotifyMessage));
                HashMap<String, Object> map = new HashMap<String, Object>();
                map.put("action", 1);
                map.put("result", hashon.fromObject(mobPushNotifyMessage));
                event.success(hashon.fromHashMap(map));
            }

            @Override
            public void onNotifyMessageOpenedReceive(Context context, MobPushNotifyMessage mobPushNotifyMessage) {
                System.out.println(">>>>>>>>>>>>>>>>>>>>onNotifyMessageOpenedReceive>>>>>>" + hashon.fromObject(mobPushNotifyMessage));
                HashMap<String, Object> map = new HashMap<String, Object>();
                map.put("action", 2);
                map.put("result", hashon.fromObject(mobPushNotifyMessage));
                event.success(hashon.fromHashMap(map));
            }

            @Override
            public void onTagsCallback(Context context, String[] tags, int operation, int errorCode) {
                System.out.println(">>>>>>>>>>>>>>>>>>>>onTagsCallback>>>>>>");
                HashMap<String, Object> map = new HashMap<String, Object>();
                map.put("action", 3);
                map.put("tags", tags);
                map.put("operation", operation);
                map.put("errorCode", errorCode);
                event.success(hashon.fromHashMap(map));
            }

            @Override
            public void onAliasCallback(Context context, String alias, int operation, int errorCode) {
                System.out.println(">>>>>>>>>>>>>>>>>>>>onAliasCallback>>>>>>");
                HashMap<String, Object> map = new HashMap<String, Object>();
                map.put("action", 4);
                map.put("alias", alias);
                map.put("operation", operation);
                map.put("errorCode", errorCode);
                event.success(hashon.fromHashMap(map));
            }
        };
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        MobPush.addPushReceiver(createMobPushReceiver(eventSink));
    }

    @Override
    public void onCancel(Object o) {

    }
}
