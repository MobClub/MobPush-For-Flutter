import { EventChannel, FlutterAbility, FlutterEngine,Any } from '@ohos/flutter_ohos';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import MobpushPlugin from 'mobpush_plugin';
import mobPush from '@zztsdk/mobpush';

export default class EntryAbility extends FlutterAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    super.onCreate(want, launchParam)
    MobpushPlugin.notificationClickAck(want)
    MobpushPlugin.receiveMessage(this)
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam): void {
    MobpushPlugin.notificationClickAck(want)
  }

  configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    GeneratedPluginRegistrant.registerWith(flutterEngine)
  }


}
