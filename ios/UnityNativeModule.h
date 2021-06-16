//
//  UnityNativeModule.h
//  RNUnityView
//
//  Created by xzper on 2018/12/13.
//  Copyright © 2018 xzper. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "UnityUtils.h"

@interface UnityNativeModule : RCTEventEmitter <RCTBridgeModule, UnityEventListener>
@end
