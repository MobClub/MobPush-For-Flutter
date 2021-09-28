package com.mob.mobpush_example;

import android.content.Intent;
import android.os.Bundle;

import com.mob.mobpush_example.utils.PlayloadDelegate;
import com.mob.pushsdk.MobPush;
import com.mob.pushsdk.MobPushUtils;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }

  @Override
  protected void onNewIntent(Intent intent) {
    super.onNewIntent(intent);
    //需要调用setIntent方法，不然后面获取到的getIntent都试上一次传的数据
    setIntent(intent);
    dealPushResponse(intent);
  }
  private void dealPushResponse(Intent intent) {
    Bundle bundle = null;
    if (intent != null) {
      MobPush.notificationClickAck(intent);
      MobPushUtils.parseMainPluginPushIntent(intent);
      bundle = intent.getExtras();
      new PlayloadDelegate().playload(this, bundle);
    }
  }
}
