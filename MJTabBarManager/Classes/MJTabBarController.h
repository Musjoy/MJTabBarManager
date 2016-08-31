//
//  MJTabBarController.h
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJTabBarManager.h"
#ifdef MODULE_THEME_MANAGER
#import "MJThemeManager.h"
#endif

/// tab bar上的banner广告 key设置
#ifndef KEY_AD_FOR_TAB
#define KEY_AD_FOR_TAB @"KEY_AD_FOR_TAB"
#endif

@interface MJTabBarController : UITabBarController

#ifdef MODULE_AD_MANAGER

@property (nonatomic, strong, readonly) IBInspectable NSString *adKey;

#endif

@property (nonatomic, strong) MJTabBarManager *tabBarManager;

@property (nonatomic, nonatomic) BOOL isViewShow;

@property (nonatomic, nonatomic) BOOL isViewHadShow;        // 是否已经现实过

- (void)reloadTheme;

@end

@interface UITabBarController (HideTabBar)

@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
