import { EventChannel, FlutterPlugin, FlutterPluginBinding, MethodChannel } from '@ohos/flutter_ohos';
import { MethodCallHandlerImpl } from './impl/MethodCallHandlerImpl';
import { StreamHandlerImpl } from './impl/StreamHandlerImpl';
import mobPush from "@zztsdk/mobpush"
import { UIAbility, Want } from '@kit.AbilityKit';


/** MobpushPlugin **/
export default class MobpushPlugin implements FlutterPlugin {
  private channel: MethodChannel | null = null;
  private eventChannel: EventChannel | null = null;

  constructor() {
  }


  getUniqueClassName(): string {
    return "MobpushPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "com.mob.mobpush.methodChannel");
    let methodImpl = new MethodCallHandlerImpl(binding.getApplicationContext())
    this.channel.setMethodCallHandler(methodImpl)
    let receiver = new StreamHandlerImpl()
    methodImpl.addReceiver(receiver)
    this.eventChannel = new EventChannel(binding.getBinaryMessenger(), "com.mob.mobpush.reciever")
    this.eventChannel.setStreamHandler(receiver)


  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  static notificationClickAck(want:Want) {
    mobPush.notificationClickAck(want)
  }

  static receiveMessage(ability: UIAbility) {
    mobPush.receiveMessage(ability)
  }
}