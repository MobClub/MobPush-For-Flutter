import { MethodCall, MethodCallHandler, MethodResult } from "@ohos/flutter_ohos"
import { deviceInfo } from "@kit.BasicServicesKit"
import mobPush from "@zztsdk/mobpush"
import Base from '@ohos.base';
import { HashMap } from "@kit.ArkTS";
import { common } from "@kit.AbilityKit";
import { ZztSDK } from '@zztsdk/zztcore';
import SimulateRequest from './req/SimulateRequest';
import { AsyncCallback } from "@kit.BasicServicesKit";
import { StreamHandlerImpl } from './StreamHandlerImpl';

export class MethodCallHandlerImpl implements MethodCallHandler {
  private context: common.Context
  private receiver: StreamHandlerImpl | undefined = undefined

  constructor(cxt: common.Context) {
    this.context = cxt
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "getPlatformVersion") {
      result.success(deviceInfo.osReleaseType)
    } else if (call.method == "getSDKVersion") {
      result.success(mobPush.SDK_VERSION_NAME)
    } else if (call.method == "init") {
      let appkey = call.argument("appKey") as string
      let appSecret = call.argument("appSecret") as string
      ZztSDK.init(this.context, appkey, appSecret)
    } else if (call.method == "updatePrivacyPermissionStatus") {
      let status = call.argument("status") as boolean
      ZztSDK.submitPolicyGrantResult(status)
    } else if (call.method == "getRegistrationId") {
      let getRegistrationIdCallback = (err: Base.BusinessError, data: string): void => {
        let map = new HashMap<string, Object>()
        if (err) {
          map.set("error", err.message)
        } else {
          map.set("res", data)
        }
        result.success(map)
      }
      mobPush.getRegistrationId(getRegistrationIdCallback)
    } else if (call.method == "removePushReceiver") {
      if (this.receiver) {
        mobPush.removePushReceiver(this.receiver)
      }
    } else if (call.method == "isNotificationEnabled") {
      mobPush.isNotificationEnabled().then((data: boolean) => {
        let map = new HashMap<string, Object>()
        map.set("res", data)
        result.success(map)
      })
    } else if (call.method == "stopPush") {
      mobPush.stopPush()
    } else if (call.method == "restartPush") {
      mobPush.restartPush()
    } else if (call.method == "isPushStopped") {
      mobPush.isPushStoppedAsync().then((isStopped) => {
        result.success(isStopped)
      })
    } else if (call.method == "setAlias") {
      let alias = call.argument("alias") as string
      mobPush.setAlias(alias).then((data: mobPush.AliasResult) => {
        let map = new HashMap<string, Object>()
        map.set("res", data.errorCode == 0 ? "success" : "failed")
        map.set("error", "")
        map.set("errorCode", data.errorCode)
        result.success(map)
      })
    } else if (call.method == "getAlias") {
      mobPush.getAlias().then((data: mobPush.AliasResult) => {
        let map = new HashMap<string, Object>()
        map.set("res", data.alias)
        map.set("error", "")
        map.set("errorCode", data.errorCode)
        result.success(map)
      })
    } else if (call.method == "deleteAlias") {
      mobPush.deleteAlias().then((data: mobPush.AliasResult) => {
        let map = new HashMap<string, Object>()
        map.set("res", data.errorCode == 0 ? "success" : "failed")
        map.set("error", "")
        map.set("errorCode", data.errorCode)
        result.success(map)
      })
    } else if (call.method == "addTags") {
      let tags: Array<string> = call.argument("tags") as Array<string>;
      mobPush.addTags(tags).then((data: mobPush.TagsResult) => {
        let map = new HashMap<string, Object>()
        map.set("res", data.errorCode == 0 ? "success" : "failed")
        map.set("error", "")
        map.set("errorCode", data.errorCode)
        result.success(map)
      })
    } else if (call.method == "getTags") {
      mobPush.getTags().then((data: mobPush.TagsResult) => {
        let map = new HashMap<string, Object>()
        map.set("res", data.tags)
        map.set("error", "")
        map.set("errorCode", data.errorCode)
        result.success(map)
      })
    } else if (call.method == "deleteTags") {
      let tags: Array<string> = call.argument("tags") as Array<string>;
      mobPush.deleteTags(tags).then((data: mobPush.TagsResult) => {
        let map = new HashMap<string, Object>()
        map.set("res", data.errorCode == 0 ? "success" : "failed")
        map.set("error", "")
        map.set("errorCode", data.errorCode)
        result.success(map)
      })
    } else if (call.method == "cleanTags") {
      mobPush.cleanTags().then((data: mobPush.TagsResult) => {
        let map = new HashMap<string, Object>()
        map.set("res", data.tags)
        map.set("error", "")
        map.set("errorCode", data.errorCode)
        result.success(map)
      })
    } else if (call.method == "setShowBadge") {
      let status = call.argument("show") as boolean
      mobPush.setShowBadge(status)
    } else if (call.method == "getShowBadge") {
      mobPush.getShowBadgeAsync().then((isShow) => {
        result.success(isShow)
      })
    } else if (call.method == "setBadgeCounts") {
      let count = call.argument("count") as number
      mobPush.setBadgeCounts(count)
    } else if (call.method == "clearAllNotification") {
      mobPush.clearAllNotification()
    } else if (call.method == "getDeviceToken") {
      mobPush.getDeviceTokenAsync().then((token) => {
        result.success(token)
      })
    } else if (call.method == "setGeofenceStatus") {
      let status = call.argument("status") as boolean
      mobPush.setGeofenceStatus(status)
    } else if (call.method == "checkTcpStatus") {
      mobPush.checkTcpStatus().then((data: boolean) => {
        result.success(data)
      })
    } else if (call.method == "getGeofenceStatus") {
      mobPush.getGeofenceStatus().then((isopen) => {
        result.success(isopen)
      })
    } else if (call.method == "deleteGeofence") {
      let id = call.argument("geofenceId") as string
      mobPush.deleteGeofence(id)
    } else if (call.method == "setUserLanguage") {
      let language = call.argument("language") as string
      mobPush.setUserLanguage(language)
    } else if (call.method == "send") {
      let type = call.argument("type") as number
      let space = call.argument("space") as number
      let content = call.argument("content") as string
      let extras = call.argument("extrasMap") as string
      let getRegistrationIdCallback: AsyncCallback<boolean> = (data): void => {
        let map = new HashMap<string, Object>()
        map.set("res", data ? "success" : "failed")
        map.set("error", "")
        result.success(map)
      }
      SimulateRequest.sendPush(type, content, space, extras, getRegistrationIdCallback)
    } else if (call.method == "addGeofenceReceiver") {
      mobPush.setGeofenceReceiver(this.receiver)
    } else if (call.method == "addInAppMessageReceiver") {
      mobPush.setInAppMessageReceiver(this.receiver)
    } else {
      result.notImplemented()
    }
  }

  addReceiver(receiver: StreamHandlerImpl) {
    this.receiver = receiver
    mobPush.addPushReceiver(receiver)
  }
}
