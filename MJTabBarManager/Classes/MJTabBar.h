//
//  MJTabBar.h
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MJTabBar : UITabBar

@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

/** 加载广告 */
- (void)loadAd:(NSString *)adKey;

- (void)refreshSelectionIndicator;

@end
