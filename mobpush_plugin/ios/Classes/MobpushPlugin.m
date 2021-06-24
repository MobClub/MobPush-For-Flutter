#import "MobpushPlugin.h"
#import <MobPush/MobPush.h>
#import <MobPush/MobPush+Test.h>
#import <MobPush/MPushNotificationConfiguration.h>
#import <MOBFoundation/MOBFoundation.h>
#import <MOBFoundation/MobSDK+Privacy.h>
#import <MOBFoundation/MobSDK.h>

@interface MobpushPlugin()<FlutterStreamHandler>
// 是否是生产环境
@property (nonatomic, assign) BOOL isPro;
// 事件回调
@property (nonatomic, copy) void (^callBack) (id _Nullable event);

@property (nonatomic, strong) NSMutableArray *tmps;

@end

@implementation MobpushPlugin

static NSString *const receiverStr = @"mobpush_receiver";

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"mob.com/mobpush_plugin" binaryMessenger:[registrar messenger]];
    MobpushPlugin* instance = [[MobpushPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel* e_channel = [FlutterEventChannel eventChannelWithName:receiverStr binaryMessenger:[registrar messenger]];
    [e_channel setStreamHandler:instance];
    
    [instance addObserver];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }
    else if ([@"getSDKVersion" isEqualToString:call.method])
    {
        //TODO: SDK 添加获取版本号接口
        result([MobPush sdkVersion]);
    }
    else if ([@"getRegistrationId" isEqualToString:call.method]) {
        [MobPush getRegistrationID:^(NSString *registrationID, NSError *error) {
            if (error) {
                result(@{@"res": @"", @"error": error.localizedDescription});
            } else {
                result(@{@"res": registrationID, @"error": @""});
            }
        }];
    }
    else if ([@"stopPush" isEqualToString:call.method])
    {
        [MobPush stopPush];
    }
    else if ([@"restartPush" isEqualToString:call.method])
    {
        [MobPush restartPush];
    }
    else if ([@"isPushStopped" isEqualToString:call.method])
    {
        result(@([MobPush isPushStopped]));
    }
    else if ([@"setAlias" isEqualToString:call.method])
    {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        if (arguments && arguments[@"alias"] && [arguments[@"alias"] isKindOfClass:[NSString class]])
        {
            [MobPush setAlias:arguments[@"alias"] result:^(NSError *error) {
                NSString *errorStr = error ? error.localizedDescription : @"";
                result(@{@"res": error ? @"failed": @"success", @"error": errorStr});
            }];
        }
        else
        {
            result(@{@"res": @"failed", @"error": @"Arguments Invaild."});
        }
    }
    else if ([@"getAlias" isEqualToString:call.method])
    {
        [MobPush getAliasWithResult:^(NSString *alias, NSError *error) {
            if (error) {
                result(@{@"res": @"", @"error": error.localizedDescription});
            } else {
                NSString *rstAlias = alias;
                if (!alias) {
                    rstAlias = @"";
                }
                result(@{@"res": rstAlias, @"error": @""});
            }
        }];
    }
    else if ([@"deleteAlias" isEqualToString:call.method])
    {
        [MobPush deleteAlias:^(NSError *error) {
            NSString *errorStr = error ? error.localizedDescription : @"";
            result(@{@"res": error ? @"failed": @"success", @"error": errorStr});
        }];
    }
    else if ([@"addTags" isEqualToString:call.method])
    {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        if (arguments && arguments[@"tags"]) {
            [MobPush addTags:arguments[@"tags"] result:^(NSError *error) {
                NSString *errorStr = error ? error.localizedDescription : @"";
                result(@{@"res": error ? @"failed": @"success", @"error": errorStr});
            }];
        }
        else
        {
            result(@{@"res": @"failed", @"error": @"Arguments Invaild."});
        }
        
    }
    else if ([@"getTags" isEqualToString:call.method])
    {
        [MobPush getTagsWithResult:^(NSArray *tags, NSError *error) {
            if (error) {
                result(@{@"res": @"", @"error": error.localizedDescription});
            } else {
                result(@{@"res": tags, @"error": @""});
            }
        }];
    }
    else if ([@"deleteTags" isEqualToString:call.method])
    {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        if (arguments && arguments[@"tags"]) {
            [MobPush deleteTags:arguments[@"tags"] result:^(NSError *error) {
                NSString *errorStr = error ? error.localizedDescription : @"";
                result(@{@"res": error ? @"failed": @"success", @"error": errorStr});
            }];
        }
        else
        {
            result(@{@"res": @"failed", @"error": @"Arguments Invaild."});
        }
    }
    else if ([@"cleanTags" isEqualToString:call.method])
    {
        [MobPush cleanAllTags:^(NSError *error) {
            NSString *errorStr = error ? error.localizedDescription : @"";
            result(@{@"res": error ? @"failed": @"success", @"error": errorStr});
        }];
    }
    else if ([@"addLocalNotification" isEqualToString:call.method])
    {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        if (arguments && arguments[@"localNotification"])
        {
            NSString *localStr = arguments[@"localNotification"];
            NSDictionary *eventParams = [MOBFJson objectFromJSONString:localStr];
            
            NSString *identifier = nil;
            
            MPushNotification *noti = [[MPushNotification alloc] init];
            if (eventParams[@"title"] && ![eventParams[@"title"] isKindOfClass:[NSNull class]])
            {
                noti.title = eventParams[@"title"];
            }
            if (eventParams[@"content"] && ![eventParams[@"content"] isKindOfClass:[NSNull class]])
            {
                noti.body = eventParams[@"content"];
            }
            if (eventParams[@"sound"] && ![eventParams[@"sound"] isKindOfClass:[NSNull class]])
            {
                noti.sound = eventParams[@"sound"];
                
            }
            if (eventParams[@"badge"] && ![eventParams[@"badge"] isKindOfClass:[NSNull class]])
            {
                noti.badge = [eventParams[@"badge"] integerValue];
            }
            if (eventParams[@"subTitle"] && ![eventParams[@"subTitle"] isKindOfClass:[NSNull class]])
            {
                noti.subTitle = eventParams[@"subTitle"];
            }
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            if (eventParams[@"extrasMap"] && ![eventParams[@"extrasMap"] isKindOfClass:[NSNull class]])
            {
                [userInfo addEntriesFromDictionary:eventParams[@"extrasMap"]];
                
            }
            if (eventParams[@"messageId"] && ![eventParams[@"messageId"] isKindOfClass:[NSNull class]])
            {
                NSString *messageId = eventParams[@"messageId"];
                userInfo[@"messageId"] = messageId;
                identifier = messageId;
            }
            
            noti.userInfo = [userInfo copy];
            
            if (eventParams[@"identifier"] && ![eventParams[@"identifier"] isKindOfClass:[NSNull class]])
            {
                identifier = eventParams[@"messageId"];
            }
            
            MPushNotificationTrigger *trigger = [MPushNotificationTrigger new];
            
            if (eventParams[@"timestamp"] && ![eventParams[@"timestamp"] isKindOfClass:[NSNull class]])
            {
                double timeStamp = [eventParams[@"timestamp"] doubleValue];
                if (timeStamp > 0)
                {
                    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSTimeInterval nowtime = [currentDate timeIntervalSince1970] * 1000;
                    NSTimeInterval tasktimeInterval = nowtime + (NSTimeInterval)timeStamp;
                    
                    if (@available(iOS 10.0, *))
                    {
                        trigger.timeInterval = timeStamp;
                    }
                    else
                    {
                        trigger.fireDate = [NSDate dateWithTimeIntervalSince1970:tasktimeInterval];
                    }
                }
            }
            
            MPushNotificationRequest *request = [MPushNotificationRequest new];
            request.requestIdentifier = identifier;
            request.content = noti;
            request.trigger = trigger;
            
            [MobPush addLocalNotification:request result:^(id result, NSError *error) {
                
            }];
        }
    }
    else if ([@"bindPhoneNum" isEqualToString:call.method])
    {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        if (arguments && arguments[@"phoneNum"])
        {
            [MobPush bindPhoneNum:arguments[@"phoneNum"] result:^(NSError *error) {
                NSString *errorStr = error ? error.localizedDescription : @"";
                result(@{@"res": error ? @"failed": @"success", @"error": errorStr});
            }];
        }
        else
        {
            result(@{@"res": @"failed", @"error": @"Arguments Invaild."});
        }
    }
    else if ([@"send" isEqualToString:call.method])
    {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        if (arguments) {
            NSInteger type = [arguments[@"type"] integerValue];
            NSString *content = arguments[@"content"];
            NSNumber *space = arguments[@"space"];
            NSDictionary *extras = (NSDictionary *)arguments[@"extrasMap"];
            NSString *sound = arguments[@"sound"];
            NSString *coverId = arguments[@"coverId"];
            [MobPush sendMessageWithMessageType:type
                                        content:content
                                          space:space
                                          sound:sound
                        isProductionEnvironment:_isPro
                                         extras:extras
                                     linkScheme:nil
                                       linkData:nil
                                        coverId:coverId
                                         result:^(NSString *workId, NSError *error) {
                NSString *errorStr = error ? error.localizedDescription : @"";
                NSString *workIdStr = workId?:@"";
                result(@{@"res": error ? @"failed": @"success", @"error": errorStr, @"workId" : workIdStr});
            }];
        }
        else
        {
            result(@{@"res": @"failed", @"error": @"Arguments Invaild."});
        }
    }
    else if ([@"setAPNsForProduction" isEqualToString:call.method])
    {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        _isPro = [arguments[@"isPro"] boolValue];
        [MobPush setAPNsForProduction:_isPro];
    }
    else if ([@"setBadge" isEqualToString:call.method])
    {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSInteger badge = [arguments[@"badge"] integerValue];
        UIApplication.sharedApplication.applicationIconBadgeNumber = badge;
        [MobPush setBadge:badge];
    }
    else if ([@"clearBadge" isEqualToString:call.method])
    {
        [MobPush clearBadge];
    }
    else if ([@"setAPNsShowForegroundType" isEqualToString:call.method])
    {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSInteger type = [arguments[@"type"] integerValue];
        [MobPush setAPNsShowForegroundType:type];
    }
    else if ([@"setCustomNotification" isEqualToString:call.method])
    {
        MPushNotificationConfiguration *config = [[MPushNotificationConfiguration alloc] init];
        config.types = MPushAuthorizationOptionsSound | MPushAuthorizationOptionsBadge | MPushAuthorizationOptionsAlert;
        [[MOBFDataService sharedInstance] setCacheData:config forKey:@"MPushNotificationConfiguration" domain:@"MOBPUSH_FLUTTER_PLUGIN"];
        [MobPush setupNotification:config];
    }
    else if ([@"updatePrivacyPermissionStatus" isEqualToString:call.method])
    {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSInteger status = [arguments[@"status"] integerValue];
        [MobSDK uploadPrivacyPermissionStatus:status onResult:^(BOOL success) {
            result(@(success));
        }];
    }
    else if ([@"setRegionId" isEqualToString:call.method]) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        int regionId = [arguments[@"regionId"] intValue];
        [MobPush setRegionID:regionId];
    }
    else if ([@"registerApp" isEqualToString:call.method]) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        NSString *appKey = arguments[@"appKey"];
        NSString *appSecret = arguments[@"appSecret"];
        [MobSDK registerAppKey:appKey appSecret:appSecret];
    }
    else
    {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - FlutterStreamHandler Protocol

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events
{
    self.callBack = events;
    return nil;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments
{
    return nil;
}

#pragma mark - 监听消息通知

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:MobPushDidReceiveMessageNotification object:nil];
    MPushNotificationConfiguration *config = [[MOBFDataService sharedInstance] cacheDataForKey:@"MPushNotificationConfiguration" domain:@"MOBPUSH_FLUTTER_PLUGIN"];
    if (config && [config isKindOfClass:MPushNotificationConfiguration.class])
    {
         [MobPush setupNotification:config];
    }
}

- (void)didReceiveMessage:(NSNotification *)notification
{
//    NSLog(@"flutter: ================ didReceiveMessage =========================");
    if ([notification.object isKindOfClass:[MPushMessage class]])
    {
        MPushMessage *message = (MPushMessage *)notification.object;
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *reslut = [NSMutableDictionary dictionary];
        switch (message.messageType)
        {
            case MPushMessageTypeCustom:
            {// 自定义消息
                [resultDict setObject:@(0) forKey:@"action"];
                if (message.notification.userInfo)
                {
                    [reslut setObject:message.notification.userInfo forKey:@"extrasMap"];
                }
                if (message.notification.body)
                {
                    [reslut setObject:message.notification.body forKey:@"content"];
                }
                if (message.messageID)
                {
                    [reslut setObject:message.messageID forKey:@"messageId"];
                }
                [reslut addEntriesFromDictionary:message.notification.convertDictionary];
            }
                break;
            case MPushMessageTypeAPNs:
            {// APNs 回调
                
                if (message.notification.userInfo)
                {
                    [reslut setObject:message.notification.userInfo forKey:@"extrasMap"];
                }
                if (message.notification.body)
                {
                    [reslut setObject:message.notification.body forKey:@"content"];
                }
                if (message.messageID)
                {
                    [reslut setObject:message.messageID forKey:@"messageId"];
                }
                [reslut addEntriesFromDictionary:message.notification.convertDictionary];
                
                [resultDict setObject:@(1) forKey:@"action"];
            }
                break;
            case MPushMessageTypeLocal:
            { // 本地通知回调
                if (message.notification.userInfo)
                {
                    [reslut setObject:message.notification.userInfo forKey:@"extrasMap"];
                }
                if (message.notification.body)
                {
                    [reslut setObject:message.notification.body forKey:@"content"];
                }
                if (message.messageID)
                {
                    [reslut setObject:message.messageID forKey:@"messageId"];
                }
                [reslut addEntriesFromDictionary:message.notification.convertDictionary];
                
                [resultDict setObject:@(1) forKey:@"action"];
            }
                break;
                
            case MPushMessageTypeClicked:
            {
                
                if (message.notification.userInfo)
                {
                    [reslut setObject:message.notification.userInfo forKey:@"extrasMap"];
                }
                if (message.notification.body)
                {
                    [reslut setObject:message.notification.body forKey:@"content"];
                }
                if (message.messageID)
                {
                    [reslut setObject:message.messageID forKey:@"messageId"];
                }
                [reslut addEntriesFromDictionary:message.notification.convertDictionary];
                
                [resultDict setObject:@(2) forKey:@"action"];
                
            }
                break;
                
            default:
                break;
        }
        if (reslut.count > 0)
        {
            [resultDict setObject:reslut forKey:@"result"];
        }
        // 回调结果
        NSString *resultDictStr = [MOBFJson jsonStringFromObject:resultDict];

        if (self.callBack)
        {
            self.callBack(resultDictStr);
        }
        else
        {
            if(_tmps)
            {
                [_tmps addObject:resultDictStr];
            }
            else
            {
                _tmps = @[resultDictStr].mutableCopy;
            }
        }
        
    }
}

- (void)setCallBack:(void (^)(id _Nullable))callBack
{
    _callBack = callBack;
    
    if (_callBack && _tmps.count)
    {
        for (NSString *obj in _tmps) {
            _callBack(obj);
        }
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
