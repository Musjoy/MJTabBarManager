//
//  MJTabBar.m
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 YouZhun. All rights reserved.
//

#import "MJTabBar.h"
#ifdef MODULE_AD_MANAGER
#import "AdManager.h"
#endif
#import <QuartzCore/QuartzCore.h>

#ifdef MODULE_AD_MANAGER
@interface MJTabBar ()<GADBannerViewDelegate>
#else
@interface MJTabBar ()
#endif

#ifdef MODULE_AD_MANAGER
@property (nonatomic, strong) DFPBannerView *bannerView;
#endif

@property (nonatomic, assign) BOOL isAdLoaded;                  /**< 广告是否加载完成 */
@property (nonatomic, assign) BOOL isAdShow;                    /**< 广告是否显示 */

@property (nonatomic, assign) BOOL needHideAd;                  /**< 是否需要隐藏广告，横屏时需要旋转 */

@property (nonatomic, assign) float adWidth;                    /**< 广告长度 */

@property (nonatomic, assign) BOOL openBounds;                  /**< 用于临时开启正确bounds取值 */

@end

@implementation MJTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [self configView];
}


- (void)configView
{
    UIDevice *device = [UIDevice currentDevice];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
    [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];
    
    self.translucent = YES;
}

- (void)loadAd
{
#ifdef MODULE_AD_MANAGER
    if ([AdManager canShowAd]) {
        _adWidth = kScreenWidth;
        CGFloat x = 0;
        UIInterfaceOrientation or = [[UIApplication sharedApplication] statusBarOrientation];
        if (or == UIInterfaceOrientationLandscapeLeft ||
            or == UIInterfaceOrientationLandscapeRight) {
            CGFloat theHeight = _adWidth;
            _adWidth = kScreenHeight;
            x = (theHeight - _adWidth) / 2;
        }
        CGFloat adHeight =  _adWidth * 50.0 / 320;
        CGRect rect = CGRectMake(x, 0, _adWidth, adHeight);
        _bannerView = [[AdManager shareInstance] createBannerAd:KEY_AD_FOR_HOME withSize:GADAdSizeFromCGSize(rect.size) receiveBlock:^{
            if (_isAdLoaded) {
                return;
            }
            _isAdLoaded = YES;
            
            [self checkAdShowState];
        } removeBlock:^{
            [self checkAdShowState];
        }];
        [_bannerView setFrame:rect];
        [_bannerView setBackgroundColor:[UIColor whiteColor]];
    }
#endif
}

- (void)orientationChanged:(NSNotification *)note  {

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return;
    }
    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    if (o == UIDeviceOrientationPortraitUpsideDown &&
        [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        return;
    }
    
    switch (o) {
        case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
        case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
            _needHideAd = NO;
            break;
        case UIDeviceOrientationLandscapeLeft:      // Device oriented horizontally, home button on the right
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            _needHideAd = YES;
            break;
        case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            _needHideAd = YES;
            break;
        default:
            break;
    }
    _needHideAd = NO;   // 只有pad会走这里，横屏也必须显示广告
    [self checkAdShowState];
}  


- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize aSize = [super sizeThatFits:size];
    return [self sizeWithThatFits:aSize ignoreHideState:NO];;
}

- (CGRect)bounds
{
    CGRect aFrame = [super bounds];
    if (_tabBarHidden && !_openBounds) {
        aFrame.size.height = 0;
    }
    return aFrame;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
}

- (CGSize)sizeWithThatFits:(CGSize)size ignoreHideState:(BOOL)ignoreHide
{
    CGSize aSize = size;
    if (_tabBarHidden && !ignoreHide) {
        aSize.height = 0;
    } else {
        if (_isAdShow && !_needHideAd) {
            CGFloat adHeight =  _adWidth * 50.0 / 320;
            aSize.height += adHeight;
        }
    }
    return aSize;
}

- (void)layoutSubviews
{

    _openBounds = YES;
    [super layoutSubviews];
    _openBounds = NO;

    if (_isAdShow && !_needHideAd) {
        CGSize aSize = [self sizeWithThatFits:[super sizeThatFits:CGSizeZero] ignoreHideState:YES];
        CGFloat offsetX = aSize.height - 48;
        for (UIView *aView in self.subviews) {
            if ([aView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                CGRect rect = aView.frame;
                rect.origin.y = offsetX;
                rect.size.height = 48;
                [aView setFrame:rect];
            }
        }
    }
}

- (void)checkAdShowState
{
#ifdef MODULE_AD_MANAGER
    if ([AdManager canShowAd]) {
        if (!_isAdLoaded) {
            return;
        }
        if (_needHideAd) {
            [_bannerView removeFromSuperview];
            [self showAd:NO];
        } else {
            if ([_bannerView superview] == nil) {
                CGRect rect = _bannerView.frame;
                rect.origin.x = (self.bounds.size.width - rect.size.width) / 2;
                [_bannerView setFrame:rect];
                [self addSubview:_bannerView];
                [_bannerView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
            }
            [self showAd:YES];
        }
    } else {
        [_bannerView removeFromSuperview];
        [self showAd:NO];
    }
#endif
    
    [self resizeSelf];
}




- (void)setTabBarHidden:(BOOL)tabBarHidden
{
    if (_tabBarHidden == tabBarHidden) {
        return;
    }
    _tabBarHidden = tabBarHidden;
    
    [self autosizingBgView];
    
    CGRect rect = self.frame;
    rect.origin.y += _tabBarHidden?(rect.size.height):(-rect.size.height);
    [self setFrame:rect];
    [self resizeSelf];
}


#pragma mark - Pravite

- (void)autosizingBgView
{
    // 背景设置自适应
    UIView *aBgView = [self.subviews objectAtIndex:0];
    [aBgView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
}

- (void)resizeSelf
{
    // 修改content view的frame
    UITabBarController *aMJTabBarVC = (UITabBarController *)self.delegate;
    // 布局当前ViewController
    [aMJTabBarVC.selectedViewController.view.layer layoutSublayers];
    
//    [aMJTabBarVC.navigationController.view.layer layoutSublayers];
//    [aMJTabBarVC.view.layer layoutSublayers];
}


#pragma mark - Veiw Update

- (void)showAd:(BOOL)isShow
{
    if (_isAdShow == isShow) {
        return;
    }
    _isAdShow = isShow;
    
    [self autosizingBgView];
    
    CGRect rect = self.frame;
    CGFloat adHeight =  _adWidth * 50.0 / 320;
    rect.size.height += _isAdShow?adHeight:(-adHeight);
    rect.origin.y -= _tabBarHidden?0:(_isAdShow?adHeight:(-adHeight));
    [self setFrame:rect];
}


@end
