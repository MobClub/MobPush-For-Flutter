import { EventSink, StreamHandler, Any } from '@ohos/flutter_ohos';
import mobPush from "@zztsdk/mobpush";
import HashMap from "@ohos.util.HashMap";

export class StreamHandlerImpl implements StreamHandler, mobPush.MobPushReceiver, mobPush.MobPushInAppMessageReceiver, mobPush.MobPushGeofenceReceiver {
  private sink: EventSink | undefined = undefined
  private cacheMessages: string[] = []

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
      "result": message
    }
    this.messageCallback(JSON.stringify(obj))
  }

  onInAppMessageShow(message: mobPush.MobPushInAppMessage): void {
    let obj: Record<string, Object> = {
      "action": 5,
      "result": message
    }
    this.messageCallback(JSON.stringify(obj))
  }

  onInAppMessageClick(message: mobPush.MobPushInAppMessage): void {
    let obj: Record<string, Object> = {
      "action": 6,
      "result": message
    }
    this.messageCallback(JSON.stringify(obj))
  }

  //通知消息
  onCustomMessageReceive(message: mobPush.MobPushCustomMessage): void {
    let map: Record<string, ESObject> = {
      "content": message.content,
      "extrasMap": message.extrasMap,
      "messageId": message.messageId,
      "timestamp": message.timestamp,
      "offlineFlag": message.offlineFlag,
      "geofenceId": message.geofenceId,
      "expirationTime": message.expirationTime,
      "locationInfo": message.locationInfo,
      "serviceTempExtras": message.serviceTempExtras,
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
      "extrasMap": message.extrasMap,
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
      "locationInfo": message.locationInfo,
      "showInApp": message.showInApp,
      "showOffTime": message.showOffTime,
      "serviceTempExtras": message.serviceTempExtras,
    }
    return map
  }
}