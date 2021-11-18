package com.mob.mobpush_plugin;

import android.content.Context;

import androidx.annotation.NonNull;

import com.mob.MobSDK;
import com.mob.OperationCallback;
import com.mob.mobpush_plugin.req.SimulateRequest;
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
import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {
    private static Hashon hashon = new Hashon();
    private static MobPushReceiver mobPushReceiver;
    private OnRemoveReceiverListener removeReceiverListener;
    private static ArrayList<MethodChannel.Result> setAliasCallback = new ArrayList<>();
    private static ArrayList<MethodChannel.Result> getAliasCallback = new ArrayList<>();
    private static ArrayList<MethodChannel.Result> getTagsCallback = new ArrayList<>();
    private static ArrayList<MethodChannel.Result> deleteAliasCallback = new ArrayList<>();
    private static ArrayList<MethodChannel.Result> addTagsCallback = new ArrayList<>();
    private static ArrayList<MethodChannel.Result> deleteTagsCallback = new ArrayList<>();
    private static ArrayList<MethodChannel.Result> cleanTagsCallback = new ArrayList<>();

    public MethodCallHandlerImpl() {
        createMobPushReceiver();
        MobPush.addPushReceiver(mobPushReceiver);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final MethodChannel.Result result) {
        try {
            Log.e("",call.method);
            if (call.method.equals("getPlatformVersion")) {
                result.success("Android " + android.os.Build.VERSION.RELEASE);
            } else if (call.method.equals("getSDKVersion")) {
                result.success(MobPush.SDK_VERSION_NAME);
            } else if (call.method.equals("getRegistrationId")) {
                MobPush.getRegistrationId(new MobPushCallback<String>() {
                    @Override
                    public void onCallback(String data) {
                        HashMap<String, Object> map = new HashMap<String, Object>();
                        map.put("res", data);
                        result.success(map);
                    }
                });
            } else if (call.method.equals("removePushReceiver")) {
                if (removeReceiverListener != null) {
                    removeReceiverListener.onRemoveReceiver();
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
                setAliasCallback.add(result);
                MobPush.setAlias(alias);
            } else if (call.method.equals("getAlias")) {
                getAliasCallback.add(result);
                MobPush.getAlias();
            } else if (call.method.equals("deleteAlias")) {
                deleteAliasCallback.add(result);
                MobPush.deleteAlias();
            } else if (call.method.equals("addTags")) {
                ArrayList<String> tags = call.argument("tags");
                addTagsCallback.add(result);
                MobPush.addTags(tags.toArray(new String[tags.size()]));
            } else if (call.method.equals("getTags")) {
                getTagsCallback.add(result);
                MobPush.getTags();
            } else if (call.method.equals("deleteTags")) {
                ArrayList<String> tags = call.argument("tags");
                deleteTagsCallback.add(result);
                MobPush.deleteTags(tags.toArray(new String[tags.size()]));
            } else if (call.method.equals("cleanTags")) {
                cleanTagsCallback.add(result);
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
                MobPush.setShowBadge(show);
            } else if (call.method.equals("bindPhoneNum")) {
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
            } else if (call.method.equals("send")) {
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
            } else if (call.method.equals("updatePrivacyPermissionStatus")) {
                boolean status = call.argument("status");
                MobSDK.submitPolicyGrantResult(status, new OperationCallback<Void>() {
                    @Override
                    public void onComplete(Void aVoid) {
                        result.success(true);
                        System.out.println("updatePrivacyPermissionStatus onComplete");
                    }

                    @Override
                    public void onFailure(Throwable throwable) {
                        result.error(throwable.toString(), null, null);
                        System.out.println("updatePrivacyPermissionStatus onFailure:" + throwable.getMessage());
                    }
                });
            } else {
                result.notImplemented();
            }
        } catch (Exception e) {
            Log.e("", e.getMessage());
        }
    }

    private static void createMobPushReceiver() {
        mobPushReceiver = new MobPushReceiver() {
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
                try {
                    HashMap<String, Object> map = new HashMap<String, Object>();
                    MethodChannel.Result result = null;
                    // 0 获取， 1 设置， 2 删除，3 清空
                    switch (operation) {
                        case 0:
                            result = getTagsCallback.remove(0);
                            map.put("res", tags == null ? new ArrayList<String>() : Arrays.asList(tags));
                            map.put("error", "");
                            map.put("errorCode", String.valueOf(errorCode));
                            break;
                        case 1:
                            result = addTagsCallback.remove(0);
                            map.put("res", errorCode == 0 ? "success" : "failed");
                            map.put("error", "");
                            map.put("errorCode", String.valueOf(errorCode));
                            break;
                        case 2:
                            result = deleteTagsCallback.remove(0);
                            map.put("res", errorCode == 0 ? "success" : "failed");
                            map.put("error", "");
                            map.put("errorCode", String.valueOf(errorCode));
                            break;
                        case 3:
                            result = cleanTagsCallback.remove(0);
                            map.put("res", errorCode == 0 ? "success" : "failed");
                            map.put("error", "");
                            map.put("errorCode", String.valueOf(errorCode));
                            break;
                    }
                    if (result != null) {
                        result.success(map);
                    }
                } catch (Exception e) {
                }
            }

            @Override
            public void onAliasCallback(Context context, String alias, int operation, int errorCode) {
                try {
                    HashMap<String, Object> map = new HashMap<String, Object>();
                    MethodChannel.Result result = null;
                    // 0 获取， 1 设置， 2 删除
                    switch (operation) {
                        case 0:
                            result = getAliasCallback.remove(0);
                            map.put("res", alias);
                            map.put("error", "");
                            map.put("errorCode", String.valueOf(errorCode));
                            break;
                        case 1:
                            result = setAliasCallback.remove(0);
                            map.put("res", errorCode == 0 ? "success" : "failed");
                            map.put("error", "");
                            map.put("errorCode", String.valueOf(errorCode));
                            break;
                        case 2:
                            result = deleteAliasCallback.remove(0);
                            map.put("res", errorCode == 0 ? "success" : "failed");
                            map.put("error", "");
                            map.put("errorCode", String.valueOf(errorCode));
                            break;
                    }
                    if (result != null) {
                        result.success(map);
                    }
                } catch (Exception e) {

                }
            }
        };
    }

    public void setRemoveReceiverListener(OnRemoveReceiverListener removeReceiverListener) {
        this.removeReceiverListener = removeReceiverListener;
    }
}
