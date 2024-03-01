package com.mob.flutter.mobpush;

import android.content.Context;

import androidx.annotation.NonNull;

import com.mob.MobSDK;
import com.mob.commons.MOBPUSH;
import com.mob.pushsdk.MobPush;
import com.mob.flutter.mobpush.impl.MethodCallHandlerImpl;
import com.mob.flutter.mobpush.impl.StreamHandlerImpl;
import com.mob.pushsdk.MobPushCustomMessage;
import com.mob.pushsdk.MobPushNotifyMessage;
import com.mob.pushsdk.MobPushReceiver;
import com.mob.tools.MobLog;
import com.mob.tools.utils.Hashon;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MobpushPlugin implements FlutterPlugin {

	private MethodChannel methodChannel;
	private MethodChannel.MethodCallHandler methodCallHandler;
	private EventChannel eventChannel;
	private EventChannel.StreamHandler streamHandler;
	private final Hashon hashon = new Hashon();

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
}
