package com.mob.mobpush_plugin.req;

import android.text.TextUtils;
import com.mob.MobCommunicator;
import com.mob.MobSDK;
import com.mob.pushsdk.MobPush;
import com.mob.pushsdk.MobPushCallback;
import java.util.HashMap;

public class SimulateRequest {
	private static final String PUB_KEY = "009cbd92ccef123be840deec0c6ed0547194c1e471d11b6f375e56038458fb18833e5bab2e1206b261495d7e2d1d9e5aa859e6d4b"
			+ "671a8ca5d78efede48e291a3f";
	private static final String MODULUS = "1dfd1d615cb891ce9a76f42d036af7fce5f8b8efaa11b2f42590ecc4ea4cff28f5f6b0726aeb76254ab5b02a58c1d5b486c39d9da"
			+ "1a58fa6ba2f22196493b3a4cbc283dcf749bf63679ee24d185de70c8dfe05605886c9b53e9f569082eabdf98c4fb0dcf07eb9bb3e647903489ff0b5d933bd004af5be"
			+ "4a1022fdda41f347f1";

	protected final static String SERVER_URL =  "https://sdk.push.mob.com/demo/v2/push";
	private static MobCommunicator mobCommunicator;

	private synchronized static MobCommunicator getMobCommunicator() {
		if (mobCommunicator == null) {
			mobCommunicator = new MobCommunicator(1024, PUB_KEY, MODULUS);
		}
		return mobCommunicator;
	}

	/**
	 * 模拟发送推送消息
	 *
	 * @param type  消息类型：1、通知测试；2、内推测试；3、定时
	 * @param text  模拟发送内容，500字节以内，UTF-8
	 * @param space 仅对定时消息有效，单位分钟，默认1分钟
	 */
	public static void sendPush(final int type, final String text, final int space, final String extras, final MobPushCallback<Boolean> callback) {
		sendPush(type, text, space, extras, null, null, callback);
	}

	/**
	 * 模拟发送推送消息
	 * @param type 消息类型：1、通知测试；2、内推测试；3、定时
	 * @param text 模拟发送内容，500字节以内，UTF-8
	 * @param space 仅对定时消息有效，单位分钟，默认1分钟
	 * @param extras 推送消息附加数据
	 * @param scheme 推送Link指定界面scheme
	 * @param data 推送Link指定界面需传输的数据
	 */
	public static void sendPush(final int type, final String text, final int space, final String extras, final String scheme, final String data, final MobPushCallback<Boolean> callback) {
		final String content;
		if (text != null && text.length() > 35) {
			content = text.substring(0, 35);
		} else {
			content = text;
		}
		MobPush.getRegistrationId(new MobPushCallback<String>() {
			public void onCallback(String regId) {
				if (TextUtils.isEmpty(regId)) {
					if (callback != null) {
						callback.onCallback(false);
					}
					return;
				}
				HashMap<String, Object> commonMap = new HashMap<String, Object>();
				commonMap.put("plat", 1);
				commonMap.put("registrationId", regId);
				commonMap.put("msgType", type);
				commonMap.put("content", content);
				commonMap.put("space", space);
				commonMap.put("appkey", MobSDK.getAppkey());
				if(!TextUtils.isEmpty(extras)){
					commonMap.put("extras", extras);
				}
				if(!TextUtils.isEmpty(scheme)){
					commonMap.put("scheme", scheme);
				}
				if(!TextUtils.isEmpty(data)){
					commonMap.put("data", data);
				}
				getMobCommunicator().request(commonMap, SERVER_URL, false, new MobCommunicator.Callback<HashMap<String, Object>>() {
					public void onResultOk(HashMap<String, Object> data) {
						if (callback != null) {
							callback.onCallback(true);
						}
					}

					public void onResultError(Throwable e) {
						if (callback != null) {
							callback.onCallback(false);
						}
					}
				});
			}
		});
	}

}
