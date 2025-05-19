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
    let message = new mobPush.MobPushNotifyMessage()
    let map: Record<string, ESObject> = {
      "style":message.style,
      "title":message.title,
      "content":message.content,
      "extrasMap":message.extrasMap,
      "messageId":message.messageId,
      "channel":message.channel,
      "dropType":message.dropType,
      "dropId":message.dropId,
      "badgeType":message.badgeType,
      "badge":message.badge,
      "tempExtras":message.tempExtras,
      "slotType":message.slotType,
      "offlineFlag":message.offlineFlag,
      "icon":message.icon,
      "image":message.image,
      "styleContent":message.styleContent,
      "linesContent":message.linesContent,
      "group":message.group,
      "label":message.label,
      "additionalText":message.additionalText,
      "briefText":message.briefText,
      "expandedTitle":message.expandedTitle,
      "timestamp":message.timestamp,
      "mobNotifyId":message.mobNotifyId,
      "isRp":message.isRph,
      "geofenceId":message.geofenceId,
      "expirationTime":message.expirationTime,
      "locationInfo":message.locationInfo,
      "showInApp":message.showInApp,
      "showOffTime":message.showOffTime,
      "serviceTempExtras":message.serviceTempExtras,
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
