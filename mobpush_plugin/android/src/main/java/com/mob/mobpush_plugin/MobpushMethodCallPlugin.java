package com.mob.mobpush_plugin;

import androidx.annotation.NonNull;

import com.mob.MobSDK;
import com.mob.OperationCallback;
import com.mob.mobpush_plugin.req.SimulateRequest;
import com.mob.pushsdk.MobPush;
import com.mob.pushsdk.MobPushCallback;
import com.mob.pushsdk.MobPushLocalNotification;
import com.mob.tools.utils.ResHelper;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MobpushMethodCallPlugin implements MethodChannel.MethodCallHandler {
    private MobpushPlugin mobpushPlugin;

    private MethodChannel methodChannel;

    MobpushMethodCallPlugin(MobpushPlugin mobpushPlugin, @NonNull BinaryMessenger messenger) {
        this.mobpushPlugin = mobpushPlugin;
        methodChannel = new MethodChannel(messenger, "mob.com/mobpush_plugin");
        methodChannel.setMethodCallHandler(this);
    }


    @Override
    public void onMethodCall(MethodCall call, @NonNull final MethodChannel.Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "getSDKVersion":
                result.success(MobPush.SDK_VERSION_NAME);
                break;
            case "getRegistrationId":
                MobPush.getRegistrationId(new MobPushCallback<String>() {
                    @Override
                    public void onCallback(String data) {
                        HashMap<String, Object> map = new HashMap<String, Object>();
                        map.put("res", data);
                        result.success(map);
                    }
                });
                break;
            case "removePushReceiver":
                if (mobpushPlugin.mobpushReceiverPlugin.mobPushReceiver != null)
                    MobPush.removePushReceiver(mobpushPlugin.mobpushReceiverPlugin.mobPushReceiver);
                break;
            case "setClickNotificationToLaunchMainActivity":
                boolean enable = call.argument("enable");
                MobPush.setClickNotificationToLaunchMainActivity(enable);
                break;
            case "stopPush":
                MobPush.stopPush();
                break;
            case "restartPush":
                MobPush.restartPush();
                break;
            case "isPushStopped":
                result.success(MobPush.isPushStopped());
                break;
            case "setAlias":
                String alias = call.argument("alias");
                mobpushPlugin.setAliasCallback.add(result);
                MobPush.setAlias(alias);
                break;
            case "getAlias":
                mobpushPlugin.getAliasCallback.add(result);
                MobPush.getAlias();
                break;
            case "deleteAlias":
                mobpushPlugin.deleteAliasCallback.add(result);
                MobPush.deleteAlias();
                break;
            case "addTags": {
                ArrayList<String> tags = call.argument("tags");
                mobpushPlugin.addTagsCallback.add(result);
                MobPush.addTags(tags.toArray(new String[tags.size()]));
                break;
            }
            case "getTags":
                mobpushPlugin.getTagsCallback.add(result);
                MobPush.getTags();
                break;
            case "deleteTags": {
                ArrayList<String> tags = call.argument("tags");
                mobpushPlugin.deleteTagsCallback.add(result);
                MobPush.deleteTags(tags.toArray(new String[tags.size()]));
                break;
            }
            case "cleanTags":
                mobpushPlugin.cleanTagsCallback.add(result);
                MobPush.cleanTags();
                break;
            case "setSilenceTime":
                int startHour = call.argument("startHour");
                int startMinute = call.argument("startMinute");
                int endHour = call.argument("endHour");
                int endMinute = call.argument("endMinute");
                MobPush.setSilenceTime(startHour, startMinute, endHour, endMinute);
                break;
            case "setTailorNotification":

                break;
            case "removeLocalNotification":
                int notificationId = call.argument("notificationId");
                result.success(MobPush.removeLocalNotification(notificationId));
                break;
            case "addLocalNotification":
                String json = call.argument("localNotification");
                MobPushLocalNotification notification = mobpushPlugin.hashon.fromJson(json, MobPushLocalNotification.class);
                result.success(MobPush.addLocalNotification(notification));
                break;
            case "clearLocalNotifications":
                result.success(MobPush.clearLocalNotifications());
                break;
            case "setNotifyIcon":
                String iconRes = call.argument("iconRes");
                int iconResId = ResHelper.getBitmapRes(MobSDK.getContext(), iconRes);
                if (iconResId > 0) {
                    MobPush.setNotifyIcon(iconResId);
                }
                break;
            case "setAppForegroundHiddenNotification":
                boolean hidden = call.argument("hidden");
                MobPush.setAppForegroundHiddenNotification(hidden);
                break;
            case "setShowBadge":
                boolean show = call.argument("show");
                MobPush.setShowBadge(show);
                break;
            case "bindPhoneNum":
                String phoneNum = call.argument("phoneNum");
                MobPush.bindPhoneNum(phoneNum, new MobPushCallback<Boolean>() {
                    @Override
                    public void onCallback(Boolean data) {
                        if (data != null) {
                            HashMap<String, Object> map = new HashMap<String, Object>();
                            map.put("res", data.booleanValue() ? "success" : "failed");
                            map.put("error", "");
                            result.success(map);
                        }
                    }
                });
                break;
            case "send":
                int type = call.argument("type");
                int space = call.argument("space");
                String content = call.argument("content");
                String extras = call.argument("extrasMap");
                SimulateRequest.sendPush(type, content, space, extras, new MobPushCallback<Boolean>() {
                    @Override
                    public void onCallback(Boolean aBoolean) {
                        if (aBoolean != null) {
                            HashMap<String, Object> map = new HashMap<String, Object>();
                            map.put("res", aBoolean.booleanValue() ? "success" : "failed");
                            map.put("error", "");
                            result.success(map);
                        }
                    }
                });
                break;
            case "updatePrivacyPermissionStatus":
                boolean status = call.argument("status");
                MobSDK.submitPolicyGrantResult(status, new OperationCallback<Void>() {
                    @Override
                    public void onComplete(Void aVoid) {
                        System.out.println("updatePrivacyPermissionStatus onComplete");
                    }

                    @Override
                    public void onFailure(Throwable throwable) {
                        System.out.println("updatePrivacyPermissionStatus onFailure:" + throwable.getMessage());
                    }
                });
                break;
            default:
                result.notImplemented();
                break;
        }
    }


    void onDestroy() {
        methodChannel.setMethodCallHandler(null);
        methodChannel = null;
    }
}
