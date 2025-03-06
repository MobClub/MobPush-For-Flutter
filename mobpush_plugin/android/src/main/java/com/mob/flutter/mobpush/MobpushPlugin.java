package com.mob.flutter.mobpush;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.mob.MobSDK;
import com.mob.commons.MOBPUSH;
import com.mob.flutter.mobpush.impl.Const;
import com.mob.flutter.mobpush.impl.Log;
import com.mob.flutter.mobpush.impl.MethodCallHandlerImpl;
import com.mob.flutter.mobpush.impl.StreamHandlerImpl;
import com.mob.pushsdk.MobPush;
import com.mob.pushsdk.MobPushCustomMessage;
import com.mob.pushsdk.MobPushNotifyMessage;
import com.mob.pushsdk.MobPushReceiver;
import com.mob.tools.MobLog;
import com.mob.tools.utils.Hashon;
import com.xiaomi.mipush.sdk.MiPushMessage;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MobpushPlugin implements FlutterPlugin {

	private MethodChannel methodChannel;
	private MethodChannel.MethodCallHandler methodCallHandler;
	private EventChannel eventChannel;
	private EventChannel.StreamHandler streamHandler;
	private final Hashon hashon = new Hashon();
	private static StreamHandlerImpl callbackStreamHandlerImpl;
	private static final Set<JSONObject> cacheObjectList = new HashSet<>();
	private static final ExecutorService executorService = Executors.newSingleThreadExecutor();

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
			final MethodCallHandlerImpl methodCallHandlerImpl = new MethodCallHandlerImpl();
			methodCallHandler = methodCallHandlerImpl;
			methodChannel.setMethodCallHandler(methodCallHandler);

			eventChannel = new EventChannel(binding.getBinaryMessenger(), "com.mob.mobpush.reciever");
			final StreamHandlerImpl streamHandlerImpl = new StreamHandlerImpl();
			streamHandler = streamHandlerImpl;
			eventChannel.setStreamHandler(streamHandler);
			methodCallHandlerImpl.setRemoveReceiverListener(streamHandlerImpl);
			callbackStreamHandlerImpl = streamHandlerImpl;

			MobPush.addPushReceiver(new MobPushReceiver() {
				@Override
				public void onCustomMessageReceive(Context context, MobPushCustomMessage mobPushCustomMessage) {
					try {
						MobLog.getInstance().i("onCustomMessageReceive:" + hashon.fromObject(mobPushCustomMessage));
						if (streamHandlerImpl != null) {
							MobLog.getInstance().i("onCustomMessageReceive messageCallback");
							streamHandlerImpl.onCustomMessageReceive(context, mobPushCustomMessage);
						}
					} catch (Throwable throwable) {
						MobLog.getInstance().i(throwable);
					}
				}

				@Override
				public void onNotifyMessageReceive(Context context, MobPushNotifyMessage mobPushNotifyMessage) {
					try {
						MobLog.getInstance().i("onCustomMessageReceive:" + hashon.fromObject(mobPushNotifyMessage));
						if (streamHandlerImpl != null) {
							MobLog.getInstance().i("onCustomMessageReceive messageCallback");
							streamHandlerImpl.onNotifyMessageReceive(context, mobPushNotifyMessage);
						}
					} catch (Throwable throwable) {
						MobLog.getInstance().i(throwable);
					}
				}

				@Override
				public void onNotifyMessageOpenedReceive(Context context, MobPushNotifyMessage mobPushNotifyMessage) {
					try {
						MobLog.getInstance().i("onNotifyMessageOpenedReceive:" + hashon.fromObject(mobPushNotifyMessage));
						if (streamHandlerImpl != null) {
							MobLog.getInstance().i("onNotifyMessageOpenedReceive messageCallback");
							streamHandlerImpl.onNotifyMessageOpenedReceive(context, mobPushNotifyMessage);
						}
					} catch (Throwable throwable) {
						MobLog.getInstance().i(throwable);
					}
				}

				@Override
				public void onTagsCallback(Context context, String[] tags, int operation, int errorCode) {
					try {
						MobLog.getInstance().i("onTagsCallback:" + operation);
						if (methodCallHandlerImpl != null) {
							MobLog.getInstance().i("onTagsCallback messageCallback");
							methodCallHandlerImpl.onTagsCallback(context, tags, operation, errorCode);
						}
					} catch (Throwable e) {
						MobLog.getInstance().i(e);
					}
				}

				@Override
				public void onAliasCallback(Context context, String alias, int operation, int errorCode) {
					try {
						MobLog.getInstance().i("onAliasCallback:" + operation);
						if (methodCallHandlerImpl != null) {
							MobLog.getInstance().i("onAliasCallback messageCallback");
							methodCallHandlerImpl.onAliasCallback(context, alias, operation, errorCode);
						}
					} catch (Throwable e) {
						MobLog.getInstance().i(e);
					}
				}
			});
			if (!cacheObjectList.isEmpty()) {
				MobLog.getInstance().d("cacheObjectList count:" + cacheObjectList.size());
				Set<JSONObject> dealObject = new HashSet<>();
				for (JSONObject jsonObject : cacheObjectList) {
					try {
						realParseManufacturerMessage(jsonObject);
						dealObject.add(jsonObject);
					} catch (Throwable t) {
						MobLog.getInstance().e(t);
					}
				}
				if (!dealObject.isEmpty()) {
					cacheObjectList.removeAll(dealObject);
				}
			}
		} catch (Throwable e) {
			MobLog.getInstance().i(e);
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

	public static void parseManufacturerMessage(final Intent intent) {
		try {
			if (intent == null) {
				Log.d("MobPushPlugin", "intent is null");
				return;
			}
			/*禁止统一回调*/
			boolean forbidCallback = intent.getBooleanExtra(Const.FORBID_CALLBACK, false);
			if (forbidCallback) {
				MobLog.getInstance().d("fob cal");
				return;
			}
			JSONObject jsonObject = parsePushIntent(intent, false);
			MobLog.getInstance().d("ManufacturerMessage:" + jsonObject);
			if (jsonObject == null || jsonObject.length() <= 0) {
				MobLog.getInstance().i("no manu data");
				return;
			}
			if (callbackStreamHandlerImpl == null) {
				cacheObjectList.add(jsonObject);
			} else {
				MobLog.getInstance().i("realParseManufacturerMessage");
				realParseManufacturerMessage(jsonObject);
			}
		} catch (Throwable throwable) {
			MobLog.getInstance().e(throwable);
		}
	}

	private static void realParseManufacturerMessage(final JSONObject jsonObject) {
		try {
			executorService.execute(new Runnable() {
				@Override
				public void run() {
					try {
						if (MobSDK.isForb()) {
							MobLog.getInstance().d("Forb");
							return;
						}
						if (jsonObject == null || jsonObject.length() <= 0) {
							MobLog.getInstance().i("no manu data");
							return;
						}
						boolean fromTcp = false;
						if (jsonObject.has(Const.FROM_TCP)) {
							fromTcp = jsonObject.getBoolean(Const.FROM_TCP);
						}
						if (fromTcp) {
							MobLog.getInstance().e("not handle pct");
							return;
						}
						/*本地回调开发者*/
						String messageId = "";
						if (jsonObject.has(Const.ID)) {
							messageId = jsonObject.getString(Const.ID);
						}
						MobPushNotifyMessage message = new MobPushNotifyMessage();
						HashMap<String, String> extra = new HashMap<>();
						message.setMessageId(messageId);
						if (jsonObject.has(Const.CHANNEL)) {
							extra.put(Const.CHANNEL, jsonObject.getString(Const.CHANNEL));
						}
						if (jsonObject.has(Const.SCHEME_DATA)) {
							extra.put(Const.SCHEME_DATA, jsonObject.getString(Const.SCHEME_DATA));
						}
						if (jsonObject.has(Const.PUSH_DATA)) {
							extra.put(Const.PUSH_DATA, jsonObject.getString(Const.PUSH_DATA));
						}
						message.setExtrasMap(extra);
						if (callbackStreamHandlerImpl != null) {
							MobLog.getInstance().i("onNotifyMessageOpenedReceive messageCallback");
							callbackStreamHandlerImpl.onNotifyMessageOpenedReceive(MobSDK.getContext(), message);
						} else {
							MobLog.getInstance().d("callbackStreamHandlerImpl null");
						}
					} catch (Throwable throwable) {
						MobLog.getInstance().d(throwable);
					}
				}
			});
		}catch (Throwable throwable){
			MobLog.getInstance().d(throwable);
		}
	}


	public static JSONObject parsePushIntent(Intent intent, boolean needMsgIfExist) {
		try {
			JSONObject result = new JSONObject();
			MobLog.getInstance().d("MobPush parsePushIntent uri:" + intent.toUri(Intent.URI_INTENT_SCHEME));
			boolean isFromTcp = intent.getBooleanExtra(Const.FROM_TCP, false);
			Bundle bundle = intent.getExtras();
			if (bundle != null) {
				for (String key : bundle.keySet()) {
					boolean hasGetPushData = result.has(Const.PUSH_DATA);
					if (!hasGetPushData && Const.PUSH_DATA.equals(key)) {
						String content = bundle.getString(key);
						JSONObject pushDataJson = new JSONObject(content);
						result.put(Const.PUSH_DATA, pushDataJson);
					}
					boolean hasGetSchemeData = result.has(Const.SCHEME_DATA);
					if (!hasGetSchemeData && Const.SCHEME_DATA.equals(key)) {
						String content = bundle.getString(key);
						JSONObject schemeDataJson = new JSONObject(content);
						result.put(Const.SCHEME_DATA, schemeDataJson);
					}

					boolean hasGetId = result.has(Const.ID);
					if (!hasGetId && Const.ID.equals(key)) {
						String content = bundle.getString(key);
						result.put(Const.ID, content);
					}

					boolean hasGeTtChannel = result.has(Const.CHANNEL);
					if (!hasGeTtChannel && Const.CHANNEL.equals(key)) {
						String content = bundle.getString(key);
						result.put(Const.CHANNEL, content);
					}

					boolean hasGetMsg = result.has(Const.MSG);
					if (!hasGetMsg && needMsgIfExist && Const.MSG.equalsIgnoreCase(key)) {
						Object msg = bundle.get(Const.MSG);
						if (msg != null) {
							result.put(Const.MSG, msg);
						}
					}
				}
			}
			//fcm 厂商id 特殊处理
			try {
				if (bundle != null) {
					String id = bundle.getString(Const.ID);
					if (id != null && !TextUtils.isEmpty(id) && !isFromTcp && id.contains("_")) {
						id = id.split("_")[0];
						result.put(Const.ID, id);
					}
				}
			} catch (Throwable e) {
				MobLog.getInstance().d(e);
			}
			//OPPO
			Uri uri = intent.getData();
			if (uri != null && !isFromTcp) {
				try {
					String pushData = uri.getQueryParameter(Const.PUSH_DATA);
					MobLog.getInstance().d("MobPush oppo pushdata" + pushData);
					if (!TextUtils.isEmpty(pushData)) {
						JSONObject pushDataJson = new JSONObject(pushData);
						result.put(Const.PUSH_DATA, pushDataJson);
					}
					String schemeData = uri.getQueryParameter(Const.SCHEME_DATA);
					MobLog.getInstance().d("MobPush oppo schemeData" + schemeData);
					if (!TextUtils.isEmpty(schemeData)) {
						JSONObject schemeDataJson = new JSONObject(schemeData);
						result.put(Const.SCHEME_DATA, schemeDataJson);
					}
					String id = uri.getQueryParameter(Const.ID);
					MobLog.getInstance().d("MobPush oppo id" + id);
					if (!TextUtils.isEmpty(id)) {
						result.put(Const.ID, id);
					}
					String channel = uri.getQueryParameter(Const.CHANNEL);
					MobLog.getInstance().d("MobPush oppo channel" + channel);
					if (!TextUtils.isEmpty(channel)) {
						result.put(Const.CHANNEL, channel);
					}
				} catch (Throwable throwable) {
					MobLog.getInstance().d("OPPO" + throwable);
				}
			}
			//XIAOMI
			try {
				if (Class.forName("com.xiaomi.mipush.sdk.MiPushMessage") != null && !isFromTcp) {
					if (bundle != null && bundle.containsKey(Const.KEY_MESSAGE)) {
						HashMap<String, String> miPushMessage = getMiPushMessage(bundle);
						if (miPushMessage != null && !miPushMessage.isEmpty()) {
							if (miPushMessage.containsKey(Const.PUSH_DATA)) {
								String pushData = miPushMessage.get(Const.PUSH_DATA);
								if (!TextUtils.isEmpty(pushData)) {
									JSONObject pushDataJson = new JSONObject(pushData);
									result.put(Const.PUSH_DATA, pushDataJson);
								}
							}
							if (miPushMessage.containsKey(Const.ID)) {
								String id = miPushMessage.get(Const.ID);
								if (!TextUtils.isEmpty(id)) {
									result.put(Const.ID, id);
								}
							}
							if (miPushMessage.containsKey(Const.CHANNEL)) {
								String channel = miPushMessage.get(Const.CHANNEL);
								if (!TextUtils.isEmpty(channel)) {
									result.put(Const.CHANNEL, channel);
								}
							}
						}
					}
				}
			} catch (Throwable throwable) {
				MobLog.getInstance().e(throwable);
			}
			MobLog.getInstance().d("MobPush parsePushIntent JSONArray:" + result);
			if (result.length() > 0) {
				result.put(Const.FROM_TCP, isFromTcp);
			}
			return result;
		} catch (Throwable throwable) {
			MobLog.getInstance().e(throwable);
		}
		return null;
	}

	private static HashMap<String, String> getMiPushMessage(Bundle bundle) {
		HashMap<String, String> map = new HashMap<>();
		try {
			for (String key : bundle.keySet()) {
				if ((Const.KEY_MESSAGE.equals(key))) {
					MiPushMessage message = (MiPushMessage) bundle.getSerializable(key);
					if (message != null && message.getExtra() != null) {
						map.putAll(message.getExtra());
					}
				}
			}
			return map;
		} catch (Throwable throwable) {
			MobLog.getInstance().d(throwable);
			return null;
		}
	}

}
