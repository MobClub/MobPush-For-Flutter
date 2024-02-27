package com.mob.flutter.mobpush.impl;

import android.content.Context;
import android.os.Handler;
import android.os.Message;

import com.mob.pushsdk.MobPushCustomMessage;
import com.mob.pushsdk.MobPushNotifyMessage;
import com.mob.pushsdk.MobPushReceiver;
import com.mob.tools.MobLog;
import com.mob.tools.utils.Hashon;
import com.mob.tools.utils.UIHandler;

import java.util.HashMap;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import io.flutter.plugin.common.EventChannel;

public class StreamHandlerImpl implements EventChannel.StreamHandler, OnRemoveReceiverListener, MobPushReceiver {

	private EventChannel.EventSink eventSink;
	private volatile boolean isRemoved = false;
	private final Object lock = new Object();
	private final Hashon hashon = new Hashon();
	private final ThreadPoolExecutor singleExecutor = new ThreadPoolExecutor(0, 1, 0, TimeUnit.MILLISECONDS, new LinkedBlockingQueue<Runnable>());

	@Override
	public void onListen(final Object o, EventChannel.EventSink eventSink) {
		MobLog.getInstance().i("onListen");
		this.eventSink = eventSink;
		this.isRemoved = false;
		try {
			synchronized (lock) {
				lock.notifyAll();
			}
		} catch (Throwable throwable) {
			MobLog.getInstance().e(throwable);
		}
	}

	@Override
	public void onCancel(Object o) {

	}

	@Override
	public void onRemoveReceiver() {
		MobLog.getInstance().e("onRemoveReceiver");
		isRemoved = true;
		eventSink = null;
		try {
			synchronized (lock) {
				lock.notifyAll();
			}
		} catch (Throwable throwable) {
			MobLog.getInstance().e(throwable);
		}
	}

	@Override
	public void onCustomMessageReceive(Context context, MobPushCustomMessage mobPushCustomMessage) {
		try {
			HashMap<String, Object> map = new HashMap<>();
			map.put("action", 0);
			map.put("result", hashon.fromJson(hashon.fromObject(mobPushCustomMessage)));
			messageCallback(map);
		} catch (Throwable t) {
			MobLog.getInstance().e(t);
		}
	}

	@Override
	public void onNotifyMessageReceive(Context context, MobPushNotifyMessage mobPushNotifyMessage) {
		try {
			HashMap<String, Object> map = new HashMap<>();
			map.put("action", 1);
			map.put("result", hashon.fromJson(hashon.fromObject(mobPushNotifyMessage)));
			messageCallback(map);
		} catch (Throwable throwable) {
			MobLog.getInstance().e(throwable);
		}
	}

	@Override
	public void onNotifyMessageOpenedReceive(Context context, MobPushNotifyMessage mobPushNotifyMessage) {
		try {
			HashMap<String, Object> map = new HashMap<>();
			map.put("action", 2);
			map.put("result", hashon.fromJson(hashon.fromObject(mobPushNotifyMessage)));
			messageCallback(map);
		} catch (Throwable throwable) {
			MobLog.getInstance().e(throwable);
		}
	}

	@Override
	public void onTagsCallback(Context context, String[] strings, int i, int i1) {

	}

	@Override
	public void onAliasCallback(Context context, String s, int i, int i1) {

	}


	public void messageCallback(final HashMap<String, Object> map) {
		singleExecutor.execute(new Runnable() {
			@Override
			public void run() {
				try {
					MobLog.getInstance().i("Stream messageCallback");
					if (isRemoved) {
						MobLog.getInstance().i("isRemoved");
						return;
					}
					if (eventSink == null) {
						synchronized (lock) {
							MobLog.getInstance().i("wait");
							lock.wait();
						}
					}
					MobLog.getInstance().i("isRemoved:" + isRemoved);
					if (eventSink != null && !isRemoved) {
						UIHandler.sendEmptyMessage(0, new Handler.Callback() {
							@Override
							public boolean handleMessage(Message message) {
								try {
									eventSink.success(hashon.fromHashMap(map));
									MobLog.getInstance().i("eventSink success");
								} catch (Throwable throwable) {
									MobLog.getInstance().e(throwable);
								}
								return false;
							}
						});
					}
				} catch (Throwable throwable) {
					MobLog.getInstance().e(throwable);
				}
			}
		});
	}
}
