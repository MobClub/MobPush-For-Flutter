import { EventChannel, FlutterAbility, FlutterEngine,Any } from '@ohos/flutter_ohos';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import MobpushPlugin from 'mobpush_plugin_ohos';
import { abilityAccessCtrl } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit';

export default class EntryAbility extends FlutterAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    super.onCreate(want, launchParam)
    MobpushPlugin.notificationClickAck(want)
    MobpushPlugin.receiveMessage(this)
    try {
      let atManager = abilityAccessCtrl.createAtManager();
      atManager.requestPermissionsFromUser(this.context,
        ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION']).then((data) => {
        console.info("data:" + JSON.stringify(data));
        console.info("data permissions:" + data.permissions);
        console.info("data authResults:" + data.authResults);
      }).catch((err: BusinessError) => {
        console.info("data:" + JSON.stringify(err));
      })
    } catch (err) {
      console.log(`catch err->${JSON.stringify(err)}`);
    }
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam): void {
    MobpushPlugin.notificationClickAck(want)
  }

  configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    GeneratedPluginRegistrant.registerWith(flutterEngine)
  }


}
