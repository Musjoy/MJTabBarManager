//
//  MJTabBarManager.m
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 YouZhun. All rights reserved.
//

#import "MJTabBarManager.h"
#import "MJTabBar.h"

static MJTabBarManager *s_tabBarManager = nil;

@implementation UIViewController (MJTabBarManager)

- (BOOL)canShowViewController
{
    return YES;
}

@end

@implementation MJTabBarManager

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        s_tabBarManager = [[MJTabBarManager alloc] init];
    });
    return s_tabBarManager;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)viewController;
        viewController = [navVC.viewControllers objectAtIndex:0];
    }
    return [viewController canShowViewController];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}


- (void)loadAd
{
    MJTabBar *theTabBar = (MJTabBar *)_tabBarController.tabBar;
    [theTabBar loadAd];
}

@end
