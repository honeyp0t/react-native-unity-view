//
//  RNUnityViewManager.h
//  RNUnityView
//
//  Created by xzper on 2018/2/23.
//  Copyright © 2018年 xzper. All rights reserved.
//

#import "RCTViewManager.h"
#import <UnityFramework/UnityFramework.h>
#import "UnityUtils.h"
#import "RNUnityView.h"

@interface RNUnityViewManager : RCTViewManager

@property (nonatomic, strong) RNUnityView *currentView;

@end
