//
//  UnityNativeModule.m
//  RNUnityView
//
//  Created by xzper on 2018/12/13.
//  Copyright © 2018 xzper. All rights reserved.
//

#import "UnityNativeModule.h"

@implementation UnityNativeModule

RCT_EXPORT_MODULE(UnityNativeModule);

- (id)init
{
    self = [super init];
    if (self) {
        [UnityUtils addUnityEventListener:self];
    }
    return self;
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"onUnityMessage"];
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

RCT_EXPORT_METHOD(isReady:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    resolve(@([UnityUtils isUnityReady]));
}

RCT_EXPORT_METHOD(createUnity:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [UnityUtils createPlayer:^{
        resolve(@(YES));
    }];
}

RCT_EXPORT_METHOD(postMessage:(NSString *)gameObject methodName:(NSString *)methodName message:(NSString *)message)
{
    UnityPostMessage(gameObject, methodName, message);
}

RCT_EXPORT_METHOD(pause)
{
    UnityPauseCommand();
}

RCT_EXPORT_METHOD(resume)
{
    UnityResumeCommand();
}

RCT_EXPORT_METHOD(setKeyWindow)
{
    SetKeyWindow();
}

- (void)onMessage:(NSString *)message {
    [self sendEventWithName:@"onUnityMessage" body:message];
}



@end
