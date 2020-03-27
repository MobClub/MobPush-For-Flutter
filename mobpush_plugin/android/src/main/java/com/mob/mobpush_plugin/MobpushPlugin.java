package com.mob.mobpush_plugin;

import androidx.annotation.NonNull;

import com.mob.pushsdk.MobPush;
import com.mob.tools.utils.Hashon;

import java.util.ArrayList;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * MobpushPlugin
 */
public class MobpushPlugin implements FlutterPlugin {
    Hashon hashon = new Hashon();
    ArrayList<MethodChannel.Result> setAliasCallback = new ArrayList<>();
    ArrayList<MethodChannel.Result> getAliasCallback = new ArrayList<>();
    ArrayList<MethodChannel.Result> getTagsCallback = new ArrayList<>();
    ArrayList<MethodChannel.Result> deleteAliasCallback = new ArrayList<>();
    ArrayList<MethodChannel.Result> addTagsCallback = new ArrayList<>();
    ArrayList<MethodChannel.Result> deleteTagsCallback = new ArrayList<>();
    ArrayList<MethodChannel.Result> cleanTagsCallback = new ArrayList<>();


    private MobpushMethodCallPlugin mobpushMethodCallPlugin;
    MobpushReceiverPlugin mobpushReceiverPlugin;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        this.onAttachedToEngine(binding.getBinaryMessenger());
    }


    private void onAttachedToEngine(@NonNull BinaryMessenger messenger) {
        mobpushMethodCallPlugin = new MobpushMethodCallPlugin(this, messenger);
        mobpushReceiverPlugin = new MobpushReceiverPlugin(this, messenger);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        mobpushMethodCallPlugin.onDestroy();
        mobpushReceiverPlugin.onDestroy();
        mobpushMethodCallPlugin = null;
        mobpushReceiverPlugin = null;
    }


    public static void registerWith(Registrar registrar) {
        MobpushPlugin mobpushPlugin = new MobpushPlugin();
        mobpushPlugin.onAttachedToEngine(registrar.messenger());
    }

}
