//
//  MJTabBarManager.m
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
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


@interface MJTabBarManager ()

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation MJTabBarManager

- (id)initWithTabBarController:(UITabBarController *)tabBarController
{
    self = [super init];
    if (self) {
        _tabBarController = tabBarController;
    }
    return self;
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
    MJTabBar *theTabBar = (MJTabBar *)tabBarController.tabBar;
    if ([theTabBar isKindOfClass:[MJTabBar class]]) {
        [theTabBar refreshSelectionIndicator];
    }
}


- (void)loadAd:(NSString *)adKey
{
    MJTabBar *theTabBar = (MJTabBar *)_tabBarController.tabBar;
    if ([theTabBar isKindOfClass:[MJTabBar class]]) {
        [theTabBar loadAd:adKey];
    }
}

@end
