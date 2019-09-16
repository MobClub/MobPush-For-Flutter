package com.mob.mobpush;

import android.content.Context;

import com.mob.MobSDK;
import com.mob.mobpush.req.SimulateRequest;
import com.mob.pushsdk.MobPush;
import com.mob.pushsdk.MobPushCallback;
import com.mob.pushsdk.MobPushCustomMessage;
import com.mob.pushsdk.MobPushLocalNotification;
import com.mob.pushsdk.MobPushNotifyMessage;
import com.mob.pushsdk.MobPushReceiver;
import com.mob.tools.utils.Hashon;
import com.mob.tools.utils.ResHelper;

import java.util.ArrayList;
import java.util.Arrays;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * MobpushPlugin
 */
public class MobpushPlugin implements MethodCallHandler {
    private Hashon hashon = new Hashon();

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "mob.com/mobpush");
        channel.setMethodCallHandler(new MobpushPlugin());

        MobpushReceiverPlugin.registerWith(registrar);
    }

    @Override
    public void onMethodCall(final MethodCall call, final Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("getRegistrationId")) {
            MobPush.getRegistrationId(new MobPushCallback<String>() {
                @Override
                public void onCallback(String data) {
                    result.success(data);
                }
            });
        } else if (call.method.equals("removePushReceiver")) {
            if (MobpushReceiverPlugin.getMobPushReceiver() != null) {
                MobPush.removePushReceiver(MobpushReceiverPlugin.getMobPushReceiver());
            }
        } else if (call.method.equals("setClickNotificationToLaunchMainActivity")) {
            boolean enable = call.argument("enable");
            MobPush.setClickNotificationToLaunchMainActivity(enable);
        } else if (call.method.equals("stopPush")) {
            MobPush.stopPush();
        } else if (call.method.equals("restartPush")) {
            MobPush.restartPush();
        } else if (call.method.equals("isPushStopped")) {
            result.success(MobPush.isPushStopped());
        } else if (call.method.equals("setAlias")) {
            String alias = call.argument("alias");
            MobPush.setAlias(alias);
        } else if (call.method.equals("getAlias")) {
            MobPush.getAlias();
        } else if (call.method.equals("deleteAlias")) {
            MobPush.deleteAlias();
        } else if (call.method.equals("addTags")) {
            ArrayList<String> tags = call.argument("tags");
            MobPush.addTags(tags.toArray(new String[tags.size()]));
        } else if (call.method.equals("getTags")) {
            MobPush.getTags();
        } else if (call.method.equals("deleteTags")) {
            ArrayList<String> tags = call.argument("tags");
            MobPush.deleteTags(tags.toArray(new String[tags.size()]));
        } else if (call.method.equals("cleanTags")) {
            MobPush.cleanTags();
        } else if (call.method.equals("setSilenceTime")) {
            int startHour = call.argument("startHour");
            int startMinute = call.argument("startMinute");
            int endHour = call.argument("endHour");
            int endMinute = call.argument("endMinute");
            MobPush.setSilenceTime(startHour, startMinute, endHour, endMinute);
        } else if (call.method.equals("setTailorNotification")) {

        } else if (call.method.equals("removeLocalNotification")) {
            int notificationId = call.argument("notificationId");
            result.success(MobPush.removeLocalNotification(notificationId));
        } else if (call.method.equals("addLocalNotification")) {
            String json = call.argument("localNotification");
            MobPushLocalNotification notification = hashon.fromJson(json, MobPushLocalNotification.class);
            result.success(MobPush.addLocalNotification(notification));
        } else if (call.method.equals("clearLocalNotifications")) {
            result.success(MobPush.clearLocalNotifications());
        } else if (call.method.equals("setNotifyIcon")) {
            String iconRes = call.argument("iconRes");
            int iconResId = ResHelper.getBitmapRes(MobSDK.getContext(), iconRes);
            if (iconResId > 0) {
                MobPush.setNotifyIcon(iconResId);
            }
        } else if (call.method.equals("setAppForegroundHiddenNotification")) {
            boolean hidden = call.argument("hidden");
            MobPush.setAppForegroundHiddenNotification(hidden);
        } else if (call.method.equals("setShowBadge")) {
            boolean show = call.argument("show");
            System.out.println("setShowBadge:"+show); 
            MobPush.setShowBadge(show);
        } else if (call.method.equals("bindPhoneNum")) {
            String phoneNum = call.argument("phoneNum");
            MobPush.bindPhoneNum(phoneNum, new MobPushCallback<Boolean>() {
                @Override
                public void onCallback(Boolean data) {
                    result.success(data);
                }
            });
        } else if (call.method.equals("send")) {
            int type = call.argument("type");
            int space = call.argument("space");
            String content = call.argument("content");
            String extras = call.argument("extras");
            SimulateRequest.sendPush(type, content, space, extras, new MobPushCallback<Boolean>() {
                @Override
                public void onCallback(Boolean aBoolean) {
                    result.success(aBoolean);
                }
            });
        } else {
            result.notImplemented();
        }
    }
}
