package com.mob.mobpush_example;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.mob.pushsdk.MobPush;
import com.mob.pushsdk.MobPushUtils;

import java.util.Set;

/**
 * scheme指定界面跳转目标页-指定界面1
 * 推送时通过scheme指定界面跳转，在AndroidManifest.xml文件中配置示例：
 * <activity
 * android:name=".LinkOneActivity"
 * android:launchMode="singleTop">
 * <intent-filter>
 * <action android:name="android.intent.action.VIEW" />
 * <category android:name="android.intent.category.DEFAULT" />
 * <data
 * android:host="com.mob.mobpush.linkone"
 * android:scheme="mlink" />
 * </intent-filter>
 * <p>
 * </activity>
 * 需添加intent-filter，配置相关action、category和data信息
 * 通过scheme://host格式填写scheme字段信息来进行指定界面推送。
 * 如果scheme指定界面携带附加数据，MobPush、魅族、小米、华为等四个推送通道进行了默认处理，把指定界面的附加数据统一放入了"data"的intent extra中，
 * 可通过getIntent().getExtras.get("data")获取附加数据；
 * 而FCM（应用非前台情况下）、OPPO通道的特殊性，无法进行默认处理，需在启动页中获取附加字段单独处理界面跳转和附加数据的传入。
 */
public class LinkOneActivity extends Activity implements View.OnClickListener {
	private final static String MOB_PUSH_NORMAL_SCHEME_PLAYLOAD_KEY = "data";

	private TextView tvTitle;
	private ImageView ivBack;
	private TextView tv;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.act_link_one);
		findView();
		initView();
		initData();
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		setIntent(intent);
		initData();
	}

	private void findView() {
		tvTitle = findViewById(R.id.tvTitle);
		ivBack = findViewById(R.id.ivBack);
		tv = findViewById(R.id.tv);
	}

	private void initView() {
		tvTitle.setText(R.string.link_one_title);
		ivBack.setOnClickListener(this);
	}

	private void initData() {
		Intent intent = getIntent();
		Uri uri = intent.getData();
		if (intent != null) {
			MobPushUtils.parseSchemePluginPushIntent(intent);
			MobPush.notificationClickAck(intent);
			System.out.println("MobPush linkone intent---" + intent.toUri(Intent.URI_INTENT_SCHEME));
		}

		StringBuilder sb = new StringBuilder();
		if (uri != null) {
			sb.append(" scheme:" + uri.getScheme() + "\n");
			sb.append(" host:" + uri.getHost() + "\n");
			sb.append(" port:" + uri.getPort() + "\n");
			sb.append(" query:" + uri.getQuery() + "\n");
		}

		//获取link界面传输的数据，取字段data数据
		Bundle bundle = intent.getExtras();
		if (bundle != null && bundle.containsKey(MOB_PUSH_NORMAL_SCHEME_PLAYLOAD_KEY)) {
			sb.append(" extras:" + (bundle.containsKey(MOB_PUSH_NORMAL_SCHEME_PLAYLOAD_KEY)
					? bundle.get(MOB_PUSH_NORMAL_SCHEME_PLAYLOAD_KEY).toString() : ""));
		}
		if (bundle != null) {
			sb.append("\n" + "bundle toString :" + bundle.toString());
			Set<String> keySet = bundle.keySet();
			for (String key : keySet) {
				System.out.println("MobPush linkone bundle------------->" + key);
				System.out.println("MobPush linkone bundle------------->" + bundle.get(key));
			}
		}
		tv.setText(sb);
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
			case R.id.ivBack: {
				finish();
			}
			break;
		}
	}
}
