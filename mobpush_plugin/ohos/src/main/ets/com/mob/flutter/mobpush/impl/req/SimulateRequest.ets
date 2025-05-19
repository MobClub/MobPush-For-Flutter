import mobPush from "@zztsdk/mobpush";
import { NetCommunicator, ZztSDK } from "@zztsdk/zztcore";
import { AsyncCallback } from "@kit.BasicServicesKit";

namespace SimulateRequest {
  let communicator: NetCommunicator | undefined = undefined
  const PUB_KEY =
    "009cbd92ccef123be840deec0c6ed0547194c1e471d11b6f375e56038458fb18833e5bab2e1206b261495d7e2d1d9e5aa859e6d4b"
      + "671a8ca5d78efede48e291a3f";

  const MODULUS =
    "1dfd1d615cb891ce9a76f42d036af7fce5f8b8efaa11b2f42590ecc4ea4cff28f5f6b0726aeb76254ab5b02a58c1d5b486c39d9da" +
      "1a58fa6ba2f22196493b3a4cbc283dcf749bf63679ee24d185de70c8dfe05605886c9b53e9f569082eabdf98c4fb0dcf07eb9bb3e647903489ff0b5d933bd004af5be" +
      "4a1022fdda41f347f1";

  const URL = "https://sdk.push.mob.com/demo/v2/push"

  export function sendPush(type: number, text: string, space: number, extras: string, callback: AsyncCallback<boolean>,
    scheme?: string, data?: string) {
    text = text.substring(0, 35)
    mobPush.getRegistrationId().then((rid) => {
      if (!rid && rid == "") {
        console.log("qqq111 rid:" + rid)
        if (callback) {
          callback(null, false)
        }
        return
      }
      let commonMap: Map<string, Object> = new Map()
      commonMap.set("plat", 8)
      commonMap.set("registrationId", rid);
      commonMap.set("msgType", type);
      commonMap.set("content", text);
      commonMap.set("space", space);
      commonMap.set("appkey", ZztSDK.getAppKey()!);
      if (extras && extras != "") {
        commonMap.set("extras", extras)
      }
      if (scheme && scheme != "") {
        commonMap.set("scheme", scheme)
      }
      if (data && data != "") {
        commonMap.set("data", data)
      }
      let headMap: Map<string, string> = new Map()
      getMobCommunicator().request(URL, commonMap)
        .then((obj: Object) => {
          callback(null, true)
        }).catch((e: Error) => {
        callback(null, false)
        console.log("qqq111 e:" + JSON.stringify(e))
      })
    })
  }

  function getMobCommunicator(): NetCommunicator {
    if (!communicator) {
      communicator = new NetCommunicator(1024, PUB_KEY, MODULUS)
    }
    return communicator
  }
}

export default SimulateRequest