#import "MobpushPlugin.h"
#import <MobPush/MobPush.h>
#import <MobPush/MobPush+Test.h>
#import <MobPush/MPushNotificationConfiguration.h>

@interface MobpushPlugin ()

@property (nonatomic, assign) BOOL isPro;
@property (nonatomic, copy) void (^callBack) (id _Nullable event);

@end

@implementation MobpushPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar
{
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"mob.com/mobpush"
            binaryMessenger:[registrar messenger]];
    MobpushPlugin* instance = [[MobpushPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel* e_channel = [FlutterEventChannel eventChannelWithName:@"mobpush_receiver" binaryMessenger:[registrar messenger]];
    [e_channel setStreamHandler:instance];
}

- (NSDictionary *)errorToUZDict:(NSError *)error
{
    NSMutableDictionary *dict = nil;
    if(error)
    {
        dict = [NSMutableDictionary new];
        NSString *des = error.userInfo[@"description"];
        NSInteger code = error.code;
        
        if(des)
        {
            dict[@"msg"] = des;
        }
        else
        {
            dict[@"msg"] = error.userInfo[NSLocalizedDescriptionKey];
        }
        dict[@"code"] = @(code);
    }
    
    return dict;
}

static NSString *const receiverStr = @"mobpush_receiver";

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    NSDictionary *arguments = call.arguments;
    if ([@"getRegistrationId" isEqualToString:call.method])
    {
        [MobPush getRegistrationID:^(NSString *registrationID, NSError *error) {
            
            if (self.callBack)
            {
                self.callBack(nil);
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
        [MobPush isPushStopped];
    }
    else if ([@"setAlias" isEqualToString:call.method])
    {
        [MobPush setAlias:arguments[@"alias"] result:^(NSError *error) {
            if (self.callBack)
            {
                self.callBack(nil);
            }
        }];
    }
    else if ([@"getAlias" isEqualToString:call.method])
    {
        [MobPush getAliasWithResult:^(NSString *alias, NSError *error) {
            
        }];
    }
    else if ([@"deleteAlias" isEqualToString:call.method])
    {
        [MobPush deleteAlias:^(NSError *error) {
            
        }];
    }
    else if ([@"addTags" isEqualToString:call.method])
    {
        [MobPush addTags:arguments[@"tags"] result:^(NSError *error) {
            
        }];
    }
    else if ([@"getTags" isEqualToString:call.method])
    {
        [MobPush getTagsWithResult:^(NSArray *tags, NSError *error) {
            
        }];
    }
    else if ([@"deleteTags" isEqualToString:call.method])
    {
        [MobPush deleteTags:arguments[@"tags"] result:^(NSError *error) {
            
        }];
    }
    else if ([@"cleanTags" isEqualToString:call.method])
    {
        [MobPush cleanAllTags:^(NSError *error) {
            
        }];
    }
    else if ([@"addLocalNotification" isEqualToString:call.method])
    {
        [MobPush addLocalNotification:nil];
    }
    else if ([@"bindPhoneNum" isEqualToString:call.method])
    {
        [MobPush bindPhoneNum:arguments[@"phoneNum"] result:^(NSError *error) {
            
        }];
    }
    else if ([@"send" isEqualToString:call.method])
    {
        [MobPush sendMessageWithMessageType:[arguments[@"type"] integerValue]
                                    content:arguments[@"content"]
                                      space:arguments[@"space"]
                    isProductionEnvironment:_isPro
                                     extras:arguments[@"extras"]
                                 linkScheme:nil
                                   linkData:nil
                                     result:^(NSError *error) {
                                     
                                 }];
    }
    else if ([@"setAPNsForProduction" isEqualToString:call.method])
    {
        _isPro = [arguments[@"isPro"] boolValue];
        [MobPush setAPNsForProduction:_isPro];
    }
    else if ([@"setBadge" isEqualToString:call.method])
    {
        [MobPush setBadge:[arguments[@"badge"] integerValue]];
    }
    else if ([@"clearBadge" isEqualToString:call.method])
    {
        [MobPush clearBadge];
    }
    else if ([@"setCustomNotification" isEqualToString:call.method])
    {
        MPushNotificationConfiguration *config = [MPushNotificationConfiguration new];
        config.types = MPushAuthorizationOptionsBadge | MPushAuthorizationOptionsBadge | MPushAuthorizationOptionsAlert;
        [MobPush setupNotification:config];
    }
    else
    {
        result(FlutterMethodNotImplemented);
    }
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events
{
    self.callBack = events;
    return nil;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments
{
    return nil;
}

@end
