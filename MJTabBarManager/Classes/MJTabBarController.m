//
//  MJTabBarController.m
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
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
    
    if (![self.tabBar isKindOfClass:[MJTabBar class]]) {
        MJTabBar *tabBar = [[MJTabBar alloc] init];
        [self setValue:tabBar forKey:@"tabBar"];
    }
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    _tabBarManager = [[MJTabBarManager alloc] initWithTabBarController:self];
    [self setDelegate:_tabBarManager];
    
#ifdef MODULE_AD_MANAGER
    if (_adKey == nil) {
        _adKey = KEY_AD_FOR_TAB;
    }
    if (_adKey.length > 0) {
        [_tabBarManager loadAd:_adKey];
    }
#endif

    self.tabBar.itemPositioning = UITabBarItemPositioningFill;
    
    [self reloadTheme];
    
#ifdef MODULE_THEME_MANAGER
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTheme) name:kNoticThemeChanged object:nil];
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
    NSLog(@"selectedIndex:%d, totalCount:%d", (int)selectedIndex, (int)[self.tabBar.subviews count]);
    for (uint i=1; i < [self.tabBar.subviews count]; i++)
    {
        UIView *view = [self.tabBar.subviews objectAtIndex:i];
        NSLog(@"class:%@",NSStringFromClass([view class]));
        if ([NSStringFromClass([view class]) isEqualToString:@"UITabBarButton"])
        {
            //view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, self.tabBar.frame.size.height);
            NSLog(@"selectedIndex:%d,i:%d", (int)self.selectedIndex, (int)i);
            if (self.selectedIndex+1==i) {
//                [self.tabBar recolorItemsWithColor:[UIColor whiteColor] shadowColor:[UIColor
//                                                                                     blackColor] shadowOffset:view.frame.size shadowBlur:0.5];
                
            }
        } 
    }
}

#pragma mark - 

- (void)reloadTheme
{
#ifdef MODULE_THEME_MANAGER
    // 主题风格
    UIBarStyle barStyle = [MJThemeManager curStyle];
    self.tabBar.barStyle = barStyle;
    // 主色调
    UIColor *tintColor = [MJThemeManager colorFor:kThemeTabTintColor];
    self.tabBar.tintColor = tintColor;
    // 背景色
    self.tabBar.barTintColor = [MJThemeManager colorFor:kThemeTabBgColor];
    // 点击背景
    UIColor *selectBgColor = [MJThemeManager colorFor:kThemeTabSelectBgColor];
    if (selectBgColor) {
        UIImage *aImg = [MJThemeManager createImageWithColor:selectBgColor andSize:CGSizeMake(3, 3)];
        aImg = [aImg resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
        self.tabBar.selectionIndicatorImage = aImg;
    } else {
        self.tabBar.selectionIndicatorImage = nil;
    }
#else
#if (defined(kTabTintColor) && defined(MODULE_UTILS))
    [self.tabBar setTintColor:kTabTintColor];
#endif
#endif
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

// 这个只在present和dismiss时回调用，最好不重写。容易引起奔溃
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return [[self selectedViewController] preferredInterfaceOrientationForPresentation];
//}

#pragma mark -

- (void)dealloc
{
#ifdef MODULE_THEME_MANAGER
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNoticThemeChanged object:nil];
#endif
}

@end
