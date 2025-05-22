import { EventChannel, FlutterPlugin, FlutterPluginBinding, MethodChannel } from '@ohos/flutter_ohos';
import { MethodCallHandlerImpl } from './impl/MethodCallHandlerImpl';
import { StreamHandlerImpl } from './impl/StreamHandlerImpl';
import mobPush from "@zztsdk/mobpush"
import { UIAbility, Want } from '@kit.AbilityKit';
import { List } from '@kit.ArkTS';


/** MobpushPlugin **/
export default class MobpushPlugin implements FlutterPlugin {
  private channel: MethodChannel | null = null;
  private eventChannel: EventChannel | null = null;
  private static cacheWant: List<Want> = new List()
  private static isAttached = false

  constructor() {
  }


  getUniqueClassName(): string {
    return "MobpushPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    MobpushPlugin.isAttached = true
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "com.mob.mobpush.methodChannel");
    let methodImpl = new MethodCallHandlerImpl(binding.getApplicationContext())
    this.channel.setMethodCallHandler(methodImpl)
    let receiver = new StreamHandlerImpl(MobpushPlugin.cacheWant)
    methodImpl.addReceiver(receiver)
    this.eventChannel = new EventChannel(binding.getBinaryMessenger(), "com.mob.mobpush.reciever")
    this.eventChannel.setStreamHandler(receiver)


  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
    if (this.eventChannel != null) {
      this.eventChannel.setStreamHandler(null)
    }
  }

  static notificationClickAck(want: Want) {
    if (!MobpushPlugin.isAttached) {
      MobpushPlugin.cacheWant.add(want)
    } else {
      mobPush.notificationClickAck(want)
    }
  }

  static receiveMessage(ability: UIAbility) {
    mobPush.receiveMessage(ability)
  }
}