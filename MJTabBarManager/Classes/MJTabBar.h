//
//  MJTabBar.h
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 YouZhun. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 首页banner广告 key设置
#ifndef KEY_AD_FOR_HOME
#define KEY_AD_FOR_HOME @"KEY_AD_FOR_HOME"
#endif

@interface MJTabBar : UITabBar

@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

/** 加载广告 */
- (void)loadAd;

@end
