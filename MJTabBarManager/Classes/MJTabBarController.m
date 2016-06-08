//
//  MJTabBarController.m
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 YouZhun. All rights reserved.
//

#import "MJTabBarController.h"
#import "MJTabBar.h"
#ifdef MODULE_UTILS
#import "UIColor+Utils.h"
#endif

#ifndef DEFAULT_ANIMATE_DURATION
#define DEFAULT_ANIMATE_DURATION 0.3
#endif

@interface MJTabBarController ()

@end

@implementation MJTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    // _tabBarManager = [[TabBarManager alloc] initWithTabBar:self];
    _tabBarManager = [MJTabBarManager shareInstance];
    [_tabBarManager setTabBarController:self];
    [self setDelegate:_tabBarManager];
    
    [_tabBarManager loadAd];

    self.tabBar.itemPositioning = UITabBarItemPositioningFill;
    
#if (defined(kTabActiveColor) && defined(MODULE_UTILS))
    [self.tabBar setTintColor:kTabActiveColor];
#endif

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _isViewShow = YES;
    _isViewHadShow = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    _isViewShow = NO;
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (CGFloat)length
{
    return 100;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    self.selectedViewController = [self.viewControllers objectAtIndex:selectedIndex];
    NSLog(@"selectedIndex:%d, totalCount:%d",selectedIndex,[self.tabBar.subviews count]);
    for (uint i=1; i < [self.tabBar.subviews count]; i++)
    {
        UIView *view = [self.tabBar.subviews objectAtIndex:i];
        NSLog(@"class:%@",NSStringFromClass([view class]));
        if ([NSStringFromClass([view class]) isEqualToString:@"UITabBarButton"])
        {
            //view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, self.tabBar.frame.size.height);
            NSLog(@"selectedIndex:%d,i:%d",self.selectedIndex,i);
            if (self.selectedIndex+1==i) {
//                [self.tabBar recolorItemsWithColor:[UIColor whiteColor] shadowColor:[UIColor
//                                                                                     blackColor] shadowOffset:view.frame.size shadowBlur:0.5];
                
            }
        } 
    }
}


@end


@implementation UITabBarController (HideTabBar)


- (BOOL)isTabBarHidden {
    return [(MJTabBar *)(self.tabBar) isTabBarHidden];
}


- (void)setTabBarHidden:(BOOL)hidden {
    [self setTabBarHidden:hidden animated:NO];
}


- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    BOOL isHidden = self.tabBarHidden;
    if(hidden == isHidden) return;

    if (!hidden) {
        self.tabBar.hidden = NO;
    }
    [UIView animateWithDuration:DEFAULT_ANIMATE_DURATION animations:^{
        [(MJTabBar *)(self.tabBar) setTabBarHidden:hidden];
    } completion:^(BOOL finished) {
        if (self.tabBarHidden) {
            self.tabBar.hidden = YES;
        }
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return  [[self selectedViewController] preferredStatusBarStyle];
}

-(BOOL)shouldAutorotate
{
    return [[self selectedViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [[self selectedViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self selectedViewController] preferredInterfaceOrientationForPresentation];
}

@end
