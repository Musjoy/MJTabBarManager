//
//  MJTabBarManager.h
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//  <MODULE_TABBAR_MANAGER>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MJTabBarManager : NSObject <UITabBarControllerDelegate>

- (id)initWithTabBarController:(UITabBarController *)tabBarController;

- (void)loadAd;

@end


/** UIViewController extension */
@interface UIViewController (MJTabBarManager)

/** 是否可以下时改ShowViewController */
- (BOOL)canShowViewController;

@end