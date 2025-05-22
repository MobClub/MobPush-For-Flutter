import { EventSink, StreamHandler, Any } from '@ohos/flutter_ohos';
import mobPush from "@zztsdk/mobpush";
import HashMap from "@ohos.util.HashMap";
import { List } from '@kit.ArkTS';
import { Want } from '@kit.AbilityKit';

export class StreamHandlerImpl implements StreamHandler, mobPush.MobPushReceiver, mobPush.MobPushInAppMessageReceiver, mobPush.MobPushGeofenceReceiver {
  private sink: EventSink | undefined = undefined
  private cacheMessages: string[] = []
  private cacheWant: List<Want> = new List()

  constructor(wants: List<Want>) {
    this.cacheWant = wants
  }

  onGeofenceReceiver(data: mobPush.MobPushGeofence[]): void {
    let obj: Record<string, Object> = {
      "action": 7,
      "result": data
    }
    this.messageCallback(JSON.stringify(obj))
  }

  //应用内消息
  onInAppMessageReceive(message: mobPush.MobPushInAppMessage): void {
    let obj: Record<string, Object> = {
      "action": 4,
      "result": this.buildInAppRealMessage(message)
    }
    this.messageCallback(JSON.stringify(obj))
  }

  onInAppMessageShow(message: mobPush.MobPushInAppMessage): void {
    let obj: Record<string, Object> = {
      "action": 5,
      "result": this.buildInAppRealMessage(message)
    }
    this.messageCallback(JSON.stringify(obj))
  }

  onInAppMessageClick(message: mobPush.MobPushInAppMessage): void {
    let obj: Record<string, Object> = {
      "action": 6,
      "result": this.buildInAppRealMessage(message)
    }
    this.messageCallback(JSON.stringify(obj))
  }

  //通知消息
  onCustomMessageReceive(message: mobPush.MobPushCustomMessage): void {
    let map: Record<string, ESObject> = {
      "content": message.content,
      "extrasMap": this.parseMap((message.extrasMap as Map<string, object>)),
      "messageId": message.messageId,
      "timestamp": message.timestamp,
      "offlineFlag": message.offlineFlag,
      "geofenceId": message.geofenceId,
      "expirationTime": message.expirationTime,
      "locationInfo": this.parseMap((message.locationInfo as Map<string, object>)),
      "serviceTempExtras": this.parseMap((message.serviceTempExtras as Map<string, object>)),
    }
    let obj: Record<string, Object> = {
      "action": 0,
      "result": map
    }
    this.messageCallback(JSON.stringify(obj))
  }

  onNotifyMessageReceive(message: mobPush.MobPushNotifyMessage): void {
    let obj: Record<string, Object> = {
      "action": 1,
      "result": this.buildRealMessage(message)
    }
    this.messageCallback(JSON.stringify(obj))
  }

  onNotifyMessageOpenedReceive(message: mobPush.MobPushNotifyMessage): void {
    let obj: Record<string, Object> = {
      "action": 2,
      "result": this.buildRealMessage(message)
    }
    this.messageCallback(JSON.stringify(obj))
  }

  onCommandReceive(type: number, map: HashMap<string, Object>): void {
    let msg: Record<string, Object> = {}
    msg["type"] = type
    for (let mapElement of map) {
      msg[mapElement[0]] = mapElement[1]
    }
    let obj: Record<string, Object> = {
      "action": 3,
      "result": msg
    }
    this.messageCallback(JSON.stringify(obj))
  }


  onListen(args: Any, events: EventSink): void {
    this.sink = events
    if (this.cacheMessages.length > 0) {
      for (let message of this.cacheMessages) {
        this.messageCallback(message)
      }
    }
    this.cacheMessages = []
    if (this.cacheWant.length > 0) {
      for (let cacheWantElement of this.cacheWant) {
        mobPush.notificationClickAck(cacheWantElement)
      }
    }
    this.cacheWant.clear()
  }

  onCancel(args: Any): void {

  }

  messageCallback(js: string) {
    if (this.sink) {
      this.sink.success(js)
    } else {
      this.cacheMessages.push(js)
    }
  }

  buildRealMessage(message: mobPush.MobPushNotifyMessage) {
    let map: Record<string, ESObject> = {
      "style": message.style,
      "title": message.title,
      "content": message.content,
      "extrasMap": this.parseMap((message.extrasMap as Map<string, object>)),
      "messageId": message.messageId,
      "channel": message.channel,
      "dropType": message.dropType,
      "dropId": message.dropId,
      "badgeType": message.badgeType,
      "badge": message.badge,
      "tempExtras": message.tempExtras,
      "slotType": message.slotType,
      "offlineFlag": message.offlineFlag,
      "icon": message.icon,
      "image": message.image,
      "styleContent": message.styleContent,
      "linesContent": message.linesContent,
      "group": message.group,
      "label": message.label,
      "additionalText": message.additionalText,
      "briefText": message.briefText,
      "expandedTitle": message.expandedTitle,
      "timestamp": message.timestamp,
      "mobNotifyId": message.mobNotifyId,
      "isRp": message.isRph,
      "geofenceId": message.geofenceId,
      "expirationTime": message.expirationTime,
      "locationInfo": this.parseMap((message.locationInfo as Map<string, object>)),
      "showInApp": message.showInApp,
      "showOffTime": message.showOffTime,
      "serviceTempExtras": this.parseMap((message.serviceTempExtras as Map<string, object>)),
    }
    return map
  }


  buildInAppRealMessage(message: mobPush.MobPushInAppMessage) {
    let map: Record<string, ESObject> = {
      "messageId": message.messageId,
      "timestamp": message.timestamp,
      "expirationTime": message.expirationTime,
      "extrasMap": this.parseMap((message.extrasMap as Map<string, object>)),
      "targetPage": message.targetPage,
      "style": message.style,
      "title": message.title,
      "titleColor": message.titleColor,
      "titleSize": message.titleSize,
      "titleAlign": message.titleAlign,
      "isTitleBold": message.isTitleBold,
      "content": message.content,
      "contentColor": message.contentColor,
      "contentSize": message.contentSize,
      "contentAlign": message.contentAlign,
      "isContentBold": message.isContentBold,
      "leftButtonText": message.leftButtonText,
      "isLeftButtonTextBold": message.isLeftButtonTextBold,
      "leftButtonTextColor": message.leftButtonTextColor,
      "leftButtonBackgroundColor": message.leftButtonBackgroundColor,
      "leftButtonClickType": message.leftButtonClickType,
      "leftButtonDeeplink": message.leftButtonDeeplink,
      "rightButtonText": message.rightButtonText,
      "isRightButtonTextBold": message.isRightButtonTextBold,
      "rightButtonTextColor": message.rightButtonTextColor,
      "rightButtonBackgroundColor": message.rightButtonBackgroundColor,
      "rightButtonClickType": message.rightButtonClickType,
      "rightButtonDeeplink": message.rightButtonDeeplink,
      "image": message.image,
      "clickType": message.clickType,
      "deeplinkUrl": message.deeplinkUrl,
      "bannerPosition": message.bannerPosition,
      "closeDelay": message.closeDelay,
      "fullCloseType": message.fullCloseType,
      "fullCloseText": message.fullCloseText,
      "isFullCloseTextBold": message.isFullCloseTextBold,
      "fullCloseTextColor": message.fullCloseTextColor,
      "fullCloseBackgroundColor": message.fullCloseBackgroundColor,
      "fullCloseTextSize": message.fullCloseTextSize,
      "closeButtonPosition": message.closeButtonPosition,
      "hasMaskLayer": message.hasMaskLayer,
      "showBannerCloseButton": message.showBannerCloseButton,
      "fromNotify": message.fromNotify,
      "serviceTempExtras": this.parseMap((message.serviceTempExtras as Map<string, object>)),
      "locationInfo": this.parseMap((message.locationInfo as Map<string, object>)),
      "geofenceId": message.geofenceId,
    }
    return map
  }

  parseMap(map: Map<string, Object>): object {
    let obj: Record<string, Object> = {};
    if (map && map.size > 0) {
      map.forEach((value, key) => {
        if (key != undefined && value != undefined) {
          obj[key] = value;
        }
      })
    }
    return obj
  }
}