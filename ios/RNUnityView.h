//
//  RNUnityView.h
//  RNUnityView
//
//  Created by xzper on 2018/2/23.
//  Copyright © 2018年 xzper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/UIView+React.h>
#import "UnityUtils.h"
#import <UnityFramework/UnityFramework.h>

@interface RNUnityView : UIView

@property (nonatomic, strong) UnityView* uView;

- (void)setUnityView:(UnityView *)view;

@end
