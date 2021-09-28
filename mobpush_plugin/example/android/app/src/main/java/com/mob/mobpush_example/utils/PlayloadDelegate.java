package com.mob.mobpush_example.utils;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import com.mob.mobpush_example.web.WebViewPage;
import com.mob.pushsdk.MobPushNotifyMessage;
import com.mob.tools.utils.Hashon;

import java.util.HashMap;
import java.util.Set;


/**
 * 推送消息携带附加数据处理类
 * >.附加数据的获取可在点击通知的落地页里的onCreate()或onNewIntent()里通过相关Intent的getExtras进行获取
 * >.落地页的附加数据大致分两种情况：1>MobPush自身通道和小米、魅族、华为三大厂商通道：
 * 1>默认落地页的情况下，针对MobPush自身通道和小米、魅族、华为三大厂商通道，需通过[msg]固定的key来获取数据
 * 2>配置scheme指定页的情况下，针对MobPush自身通道和小米、魅族、华为三大厂商通道，MobPush内部已经处理跳转指定页，并可通过Intent的getExtras用[data]进行获取指定页的附加数据
 * <p>
 * 2>OPPO通道：默认落地页和配置scheme指定页都是打开默认启动页（OPPO系统控制打开默认启动页），在默认启动页中
 * 附加数据都在[pluginExtra]的固定key中获取，如果配置了scheme指定页，对于OPPO通道来说是不生效的，需自行在代码
 * 中通过[mobpush_link_k]来获取scheme处理跳转，如果同时携带了scheme的附加数据则需通过[mobpush_link_v]获取数据
 * <p>
 * 3>FCM通道： 默认落地页和配置scheme指定页都是打开默认启动页（google 服务控制打开默认启动页），而且附加字段完全暴露在从Intent的getExtras的Bundle中，
 * 配置了scheme，对于FCM通道来说也是不生效的，需自行在代码中通过[mobpush_link_k]来获取scheme处理跳转，如果同时携带了scheme的附加数据则需通过[mobpush_link_v]获取数据
 */
public class PlayloadDelegate {
	//固定推送附加字段:
	private final static String MOB_PUSH_SCHEME_KEY = "mobpush_link_k";
	private final static String MOB_PUSH_SCHEME_PLAYLOAD_KEY = "mobpush_link_v";
	private final static String MOB_PUSH_OPPO_EXTRA_DATA = "pluginExtra";
	private final static String MOB_PUSH_NORMAL_PLAYLOAD_KEY = "msg";
	private final static String MOB_PUSH_NORMAL_SCHEME_PLAYLOAD_KEY = "data";

	//如果是从后台的扩展参数传，则可以随意定义:
	private final static String MOB_PUSH_DEMO_URL = "url";

	public void playload(Context context, Bundle bundle) {
		try {
			if (bundle == null) {
				return;
			}

			Set<String> keySet = bundle.keySet();
			if (keySet == null || keySet.isEmpty()) {
				return;
			}
			HashMap<String, Object> map = new HashMap<String, Object>();
			for (String key : keySet) {
				System.out.println("MobPush playload bundle------------->" + key);
				System.out.println("MobPush playload bundle------------->" + bundle.get(key));

				if (key.equals(MOB_PUSH_OPPO_EXTRA_DATA)) {
					map = parseOPPOPlayload(bundle);

				} else if (key.equals(MOB_PUSH_NORMAL_PLAYLOAD_KEY)) {
					map = parseNormalPlayload(bundle);

				} else {
					Object object = bundle.get(key);
					System.out.println(">>>>>>key: " + key + ", object: " + object);
					map.put(key, String.valueOf(object));
				}
			}

			if (map != null && !map.isEmpty()) {
				realPerform(context, map);
			}
		} catch (Throwable throwable) {
			Log.e("MobPush playload", throwable.getMessage());
		}
	}

	private void realPerform(Context context, HashMap<String, Object> map) {
		if (map == null) {
			return;
		}
		String json = "";

		Set<String> keys = map.keySet();
		for (String key : keys) {
			System.out.println(">>>>>>>>>>all key: " + key + ", value: " + map.get(key));
		}

		if (keys != null && keys.size() == 1 && (keys.contains("profile") || keys.contains("workId"))) {
			return;
		}

		for (String key : keys) {
			if (!"profile".equals(key) && !"workId".equals(key)
					&& !"collapse_key".equals(key) && !key.startsWith("google.") && !"from".equals(key)) {
				json += "key: " + key + ", value: " + map.get(key) + "\n";
			}
		}
//		Toast.makeText(context, json, Toast.LENGTH_SHORT).show();

		//通过配置scheme跳转指定界面则需使用固定的key来获取相关数据
		if (map.containsKey(MOB_PUSH_SCHEME_KEY)) {
			openAct(context, map);
		} else {
			//处理其他自定义数据的业务逻辑，例如打开网页：通过自定义的key来获取对应的数据
			if (map.containsKey(MOB_PUSH_DEMO_URL)) {
				openUrl(context, map);
			} else if (map.containsKey(MOB_PUSH_NORMAL_SCHEME_PLAYLOAD_KEY)) {
				System.out.println(">>>>>>>>>>scheme Activity with playload data: " + MOB_PUSH_NORMAL_SCHEME_PLAYLOAD_KEY + ", value: " + map.get(MOB_PUSH_NORMAL_SCHEME_PLAYLOAD_KEY));
			} else {

			}
		}
	}

	private HashMap<String, Object> parseOPPOPlayload(Bundle bundle) {
		HashMap hashMap = null;
		String v = String.valueOf(bundle.get(MOB_PUSH_OPPO_EXTRA_DATA));
		if (!TextUtils.isEmpty(v)) {
			hashMap = new Hashon().fromJson(v);
		}
		return hashMap;
	}

	private HashMap<String, Object> parseNormalPlayload(Bundle bundle) {
		HashMap hashMap = null;
		try {
			MobPushNotifyMessage notifyMessage = (MobPushNotifyMessage) bundle.getSerializable(MOB_PUSH_NORMAL_PLAYLOAD_KEY);
			if (notifyMessage != null) {
				hashMap = notifyMessage.getExtrasMap();
			}
		} catch (Throwable throwable) {
			Log.e("MobPush", throwable.getMessage());
			hashMap = new HashMap();
		}
		return hashMap;
	}

	private void openUrl(Context context, HashMap<String, Object> params) {
		String url;
		if (!TextUtils.isEmpty((CharSequence) params.get(MOB_PUSH_DEMO_URL))) {
			url = (String) params.get(MOB_PUSH_DEMO_URL);
		} else {
			url = "http://m.mob.com";
		}
		if (!url.startsWith("http://") && !url.startsWith("https://")) {
			url = "http://" + url;
		}
		System.out.println("url:" + url);
		WebViewPage webViewPage = new WebViewPage();
		webViewPage.setJumpUrl(url);
		webViewPage.show(context, null);
	}

	private void openAct(Context context, HashMap<String, Object> params) {
		String uri = params.containsKey(MOB_PUSH_SCHEME_KEY) ? (String) params.get(MOB_PUSH_SCHEME_KEY) : "";
		if (TextUtils.isEmpty(uri)) {
			return;
		}
		Intent intent = new Intent(null, Uri.parse(uri));
		intent.setPackage(context.getPackageName());
		if (params.containsKey(MOB_PUSH_SCHEME_PLAYLOAD_KEY) && params.get(MOB_PUSH_SCHEME_PLAYLOAD_KEY) != null) {
			intent.putExtra("data", (String) params.get(MOB_PUSH_SCHEME_PLAYLOAD_KEY));
		}
		context.startActivity(intent);
	}

}
