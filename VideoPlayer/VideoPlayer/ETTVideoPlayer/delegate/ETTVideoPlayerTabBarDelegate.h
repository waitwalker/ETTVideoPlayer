//
//  ETTVideoPlayerTabBarDelegate.h
//  ETTVideoPlayer
//
//  Created by LiuChuanan on 2017/6/7.
//  Copyright © 2017年 waitWalker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ETTVideoPlayerTabBar;

@protocol ETTVideoPlayerTabBarDelegate <NSObject>

/* 播放暂停代理回调 */
- (void)tappedInPlayerTabBar:(ETTVideoPlayerTabBar *)playerTabBar playPauseButton:(UIButton *)button;

/* 放大缩小代理回调 */
- (void)tappedInPlayerTabBar:(ETTVideoPlayerTabBar *)playerTabBar largeSmallButton:(UIButton *)button;

@end
